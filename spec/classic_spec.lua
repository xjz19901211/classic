describe('classic', function()
  local Class = require 'classic'
  local User = nil

  before_each(function()
    User = Class:extend('User')
  end)

  describe(':extend', function()
    it('should create new class', function()
      assert.is_equal(User._super, Class)
      assert.is_equal(User._class_name, 'User')
      assert.is_equal(User.__index, User)
      assert.is_equal(getmetatable(User), Class)
    end)

    it('should set class_name to Object if no give name', function()
      Other = Class:extend()
      assert.is_equal(Other._class_name, 'Object')
    end)

    it('should inherit parent class', function()
      User.__meta_methods = function() end
      Admin = User:extend('Admin')
      assert.is_equal(Admin.__meta_method, User.__meta_method)
      assert.is_equal(Admin._super, User)
      assert.is_equal(Admin._class_name, 'Admin')
      assert.is_equal(Admin.__index, Admin)
      assert.is_equal(getmetatable(Admin), User)
    end)
  end)

  describe('.new', function()
    it('should call :init and return instance', function()
      function User:init(name) self.name = name end
      user = User.new('hello')
      assert.is_equal(user._class_name, 'User')
      assert.is_equal(user.name, 'hello')
      assert.is_equal(getmetatable(user), User)
    end)
  end)

  describe(':super_call', function()
    it('should call super class method', function()
      function User:test(v) self.t = v end
      Admin = User:extend()
      function Admin:test(v) self.t = v * 2 end

      a = Admin.new('n')
      a:test(1)
      assert.is_equal(a.t, 2)
      a:super_call('test', 1)
      assert.is_equal(a.t, 1)
    end)
  end)

  describe(':include', function()
    UserRole = {}
    function UserRole:setRole(r) self.role = r end

    it('should include target methods', function()
      User:include(UserRole)
      u = User.new()
      u:setRole('admin')
      assert.is_equal(u.role, 'admin')
    end)

    it('should not cover method', function()
      function User:setRole(r) self.r = r end
      User:include(UserROle)
      u = User.new()
      u:setRole('admin')
      assert.is_equal(u.role, nil)
      assert.is_equal(u.r, 'admin')
    end)
  end)

  describe(':is', function()
    it('should return true if instance of target', function()
      u = User.new()
      assert.is_equal(u:is(User), true)
      assert.is_equal(u:is(Class), true)
    end)

    it('should return false if not instance of target', function()
      Other = Class:extend()
      u = User.new()
      assert.is_equal(u:is(Other), false)
    end)
  end)

  describe('tostring', function()
    it('should return class_name', function()
      assert.is_equal(tostring(Class), 'Object')
      assert.is_equal(tostring(User), 'User')
      o = User:extend('Other')
      assert.is_equal(tostring(o), 'Other')
    end)
  end)
end)

