--保存类类型的虚表
local _class = {}

-- 自定义类型
ClassType = {
	class = 1,
	instance = 2,
	rpc_class = 3,
	rpc_instance = 4,
	entity_class = 5,
	entity_instance = 6,
}

function BaseClass(classname, super)
	assert(type(classname) == "string" and #classname > 0)
	-- 生成一个类类型
	---@class BaseClass
	local class_type = {}
    
	-- 在创建对象的时候自动调用
	---@type function
	class_type.__init = false  --这里不设置 可能会导致子类如果没有定义__init函数，会调用多次基类的__init函数
	---@type function
	class_type.__delete = false  --这里不设置 可能会导致子类如果没有定义__delete函数，会调用多次基类的__delete函数
	class_type.__cname = classname
	class_type.__ctype = ClassType.class
	
	class_type.super = super
	
	class_type.New = function(...)
		-- 生成一个类对象
		local obj = {}
		obj._class_type = class_type
		obj.__ctype = ClassType.instance
		
		-- 在初始化之前注册基类方法
		setmetatable(obj, { 
			__index = _class[class_type],
		})
		-- 调用初始化方法
		do
			local create
			create = function(c, ...)
				if c.super then
					create(c.super, ...)
				end
				if c.__init then
					c.__init(obj, ...)
				end
			end

			create(class_type, ...)
		end

		-- 注册一个delete方法
		obj.Delete = function(self)
			local now_super = self._class_type 
			while now_super ~= nil do	
				if now_super.__delete then
					now_super.__delete(self)
				end
				now_super = now_super.super
			end
		end

		return obj
	end
	
	class_type.__call = class_type.New
	local vtbl = {}
	_class[class_type] = vtbl
 
	setmetatable(class_type, {
		__newindex = function(t,k,v)
			vtbl[k] = v
		end,
		--For call parent method
		__index = vtbl,
		__tostring = function (t)
			return classname
		end,
	})
 
	if super then
		setmetatable(vtbl, {
			__index = function(t,k)
				local ret = _class[super][k]
				--do not do accept, make hot update work right!
				--vtbl[k] = ret
				return ret
			end
		})
	end
 
	return class_type
end
