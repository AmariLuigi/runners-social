const Group = require('../models/group');

// Create a new group
const createGroup = async (req, res) => {
  try {
    const group = new Group({
      ...req.body,
      creator: req.user._id
    });
    await group.save();
    res.status(201).json(group);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all public groups or groups where user is a member
const getGroups = async (req, res) => {
  try {
    const groups = await Group.find({
      $or: [
        { 'settings.privacy': 'public' },
        { 'members.user': req.user._id }
      ]
    }).populate('members.user', 'username profile.firstName profile.lastName');
    res.json(groups);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a specific group by ID
const getGroup = async (req, res) => {
  try {
    const group = await Group.findById(req.params.id)
      .populate('members.user', 'username profile.firstName profile.lastName')
      .populate('pendingInvites.user', 'username profile.firstName profile.lastName')
      .populate('joinRequests.user', 'username profile.firstName profile.lastName');
    
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user has access to private group
    if (group.settings.privacy === 'private' && 
        !group.members.some(member => member.user._id.equals(req.user._id))) {
      return res.status(403).json({ error: 'Access denied' });
    }

    res.json(group);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update group settings
const updateGroup = async (req, res) => {
  try {
    const group = await Group.findById(req.params.id);
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user is admin
    const memberRecord = group.members.find(member => 
      member.user.equals(req.user._id) && member.role === 'admin'
    );
    if (!memberRecord) {
      return res.status(403).json({ error: 'Only admins can update group settings' });
    }

    const allowedUpdates = [
      'name', 'description', 'settings.privacy', 'settings.maxMembers',
      'settings.allowInvites', 'settings.runningPreferences'
    ];
    const updates = Object.keys(req.body);
    const isValidOperation = updates.every(update => allowedUpdates.includes(update));

    if (!isValidOperation) {
      return res.status(400).json({ error: 'Invalid updates' });
    }

    updates.forEach(update => {
      if (update.includes('.')) {
        const [key, subKey] = update.split('.');
        group[key][subKey] = req.body[update];
      } else {
        group[update] = req.body[update];
      }
    });

    await group.save();
    res.json(group);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Join a group
const joinGroup = async (req, res) => {
  try {
    const group = await Group.findById(req.params.id);
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user is already a member
    if (group.members.some(member => member.user.equals(req.user._id))) {
      return res.status(400).json({ error: 'Already a member of this group' });
    }

    // Handle private groups
    if (group.settings.privacy === 'private') {
      // Check if user has a pending invite
      const hasInvite = group.pendingInvites.some(invite => 
        invite.user.equals(req.user._id)
      );
      if (!hasInvite) {
        // Create join request
        group.joinRequests.push({ user: req.user._id });
        await group.save();
        return res.json({ message: 'Join request sent' });
      }
    }

    // Add user as member
    group.members.push({
      user: req.user._id,
      role: 'member'
    });

    // Remove from pending invites if exists
    group.pendingInvites = group.pendingInvites.filter(invite => 
      !invite.user.equals(req.user._id)
    );

    await group.save();
    res.json(group);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Leave a group
const leaveGroup = async (req, res) => {
  try {
    const group = await Group.findById(req.params.id);
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user is the creator
    if (group.creator.equals(req.user._id)) {
      return res.status(400).json({ error: 'Creator cannot leave the group' });
    }

    // Remove user from members
    group.members = group.members.filter(member => 
      !member.user.equals(req.user._id)
    );

    await group.save();
    res.json({ message: 'Successfully left the group' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Invite user to group
const inviteToGroup = async (req, res) => {
  try {
    const { userId } = req.body;
    const group = await Group.findById(req.params.id);
    
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user has permission to invite
    const memberRecord = group.members.find(member => 
      member.user.equals(req.user._id)
    );
    if (!memberRecord || (memberRecord.role === 'member' && !group.settings.allowInvites)) {
      return res.status(403).json({ error: 'No permission to invite' });
    }

    // Check if user is already a member
    if (group.members.some(member => member.user.equals(userId))) {
      return res.status(400).json({ error: 'User is already a member' });
    }

    // Check if invite already exists
    if (group.pendingInvites.some(invite => invite.user.equals(userId))) {
      return res.status(400).json({ error: 'Invite already sent' });
    }

    group.pendingInvites.push({
      user: userId,
      invitedBy: req.user._id
    });

    await group.save();
    res.json(group);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Handle join request (accept/reject)
const handleJoinRequest = async (req, res) => {
  try {
    const { userId, accept } = req.body;
    const group = await Group.findById(req.params.id);
    
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user is admin/moderator
    const memberRecord = group.members.find(member => 
      member.user.equals(req.user._id) && ['admin', 'moderator'].includes(member.role)
    );
    if (!memberRecord) {
      return res.status(403).json({ error: 'No permission to handle requests' });
    }

    // Find and remove join request
    const requestIndex = group.joinRequests.findIndex(request => 
      request.user.equals(userId)
    );
    if (requestIndex === -1) {
      return res.status(404).json({ error: 'Join request not found' });
    }

    group.joinRequests.splice(requestIndex, 1);

    if (accept) {
      // Add user as member
      group.members.push({
        user: userId,
        role: 'member'
      });
    }

    await group.save();
    res.json(group);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update member role
const updateMemberRole = async (req, res) => {
  try {
    const { userId, newRole } = req.body;
    const group = await Group.findById(req.params.id);
    
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    // Check if user is admin
    const adminRecord = group.members.find(member => 
      member.user.equals(req.user._id) && member.role === 'admin'
    );
    if (!adminRecord) {
      return res.status(403).json({ error: 'Only admins can update roles' });
    }

    // Find member to update
    const memberRecord = group.members.find(member => 
      member.user.equals(userId)
    );
    if (!memberRecord) {
      return res.status(404).json({ error: 'Member not found' });
    }

    // Prevent changing creator's role
    if (group.creator.equals(userId)) {
      return res.status(400).json({ error: 'Cannot change creator\'s role' });
    }

    memberRecord.role = newRole;
    await group.save();
    res.json(group);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

module.exports = {
  createGroup,
  getGroups,
  getGroup,
  updateGroup,
  joinGroup,
  leaveGroup,
  inviteToGroup,
  handleJoinRequest,
  updateMemberRole
};
