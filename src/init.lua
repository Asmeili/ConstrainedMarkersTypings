--[==[
# ConstrainedMarkers

Display a GUI marker of a 3D position, constrained to a boundary.

## Synopsis

	container = ConstrainedMarkers.New(boundary)
	boundary = MarkerContainer:BoundaryGUI()
	MarkerContainer:SetBoundaryType(type, ...)
	MarkerContainer:SetEnabled(enabled)
	MarkerContainer:SetConstraintType(type)
	MarkerContainer:SetArrowsEnabled(enabled)
	MarkerContainer:SetOrigin(origin)
	markerState = MarkerContainer:CreateMarker(initialState)
	markerStates = MarkerContainer:Markers()
	MarkerContainer:RemoveMarkers(...)
	MarkerContainer:RemoveAllMarkers()
	MarkerContainer:UpdateMarkers(...)

## Changelog

- v1.1 (2017-12-19)
	- Support Attachment as marker target.
	- Configurable default marker appearance: size, color, transparency, icon.
	- Compensate for rotation of boundary GUI.
	- Compensate for negative size of boundary GUI.
	- Check argument types.
	- Format docs in Markdown.
- v1.0 (2017-12-18)
	- SetBoundaryType: How boundary is shaped.
		- Rectangle
			- LerpSlide variation (default)
			- SquareSlide variation
			- CircleSlide variation
	- SetConstraintType: How markers behave outside boundary.
	- SetArrowsEnabled: Show/hide arrows globally.
		- ArrowEnabled: Per-marker override.
	- SetOrigin: Position markers from specified Camera, or CurrentCamera.
	- BodyGUI/ArrowGUI: Create markers with a basic default appearance, or
	  specified GUIs for custom appearance.
	- Supports Vector3, CFrame, BasePart, or Model as marker target.

## Usage

This module returns a table.

	ConstrainedMarkers = require(...)

A MarkerContainer can be created with the New function.

	container = ConstrainedMarkers.New(boundary)

The New function can receive an optional GuiObject, which will become the
boundary GUI. This is used to contain all the marker GUIs in the container.
Its Position and Size also determine the boundary limits. If no value is
given, then a default will be created. If needed, the boundary GUI can be
retrieved like so:

	boundary = container:BoundaryGUI()

MarkerContainer influences the following properties of the boundary GUI:

- Visible: Set to true when the container becomes enabled, set to false when
  the container becomes disabled.

Markers are added to the container with CreateMarker. This receives a table
specifying the initial values of the marker.

	marker = container:CreateMarker({
		Target = workspace.Part,
	})

CreateMarker returns the marker, which is a table that holds the marker's
state. This state is read by the container every update cycle, which occurs
every render frame.

A marker can be removed with RemoveMarkers. This receives any number of valid
markers.

	container:RemoveMarkers(marker)

If a value in the marker state is changed, then UpdateMarkers should be called
with the marker afterwards. While this may not be necessary in some cases, it
will ensure that the change is recognized by the container. UpdateMarkers can
receive any number of valid markers as arguments.

	marker.Target = workspace.AnotherPart
	container:UpdateMarkers(marker)

A marker's state contains the BodyGUI and ArrowGUI fields for retrieving and
setting the marker's GUI. When one or both of these fields is unspecified
while creating the marker, a simple default is created instead.

BodyGUI is the main GUI for the marker. MarkerContainer influences the
following properties of the BodyGUI:

- Position: Overridden to appear over or near the target.
- Visible: Overridden to show or hide the marker.
- Parent: Set to the boundary GUI when the marker is created. Set to nil when
  the marker is removed.

ArrowGUI is used to point at the target while the marker is constrained.
MarkerContainer influences the following properties of the ArrowGUI:

- Rotation: Overridden to point the arrow at the target.
- Visible: Overridden to show or hide the arrow.
- Parent: Set to the BodyGUI when the marker is created. Set to nil when the
  marker is removed.

Other than the overridden properties, both the BodyGUI and ArrowGUI can be
modified to meet the desired appearance. To detect changes made by the
MarkerContainer, use of GetPropertyChangedSignal and Changed is recommended
and encouraged.

## Reference

*Note: By convention, only fields that start with an uppercase letter are
considered to be a part of this module's public API. Other exposed fields are
considered private, may change at any time, and should therefore not be
accessed.*

--------------------------------------------------------------------------------

### `container = ConstrainedMarkers.New(boundary, enabled, defaults)`

Create a new container for constrained markers.

#### Arguments

- boundary (GuiObject, nil)

	Used as the parent of marker GUIs.

	The limits of the boundary depends on the size of the GUI. Note that,
	since only the position of a marker is constrained, the marker's body may
	still appear slightly outside the boundary.

	Defaults to a basic GUI object copied from a template.

- enabled (boolean, nil)

	Sets whether the container will be enabled immediately, before being
	returned by New.

	Defaults to true.

- defaults (table, nil)

	If specified, configures the appearance of the default marker template.
	The following fields are recognized:

	- Size (UDim, nil)

		Sets the width and height of the marker's BodyGUI. The Scale component
		is applied to both axes, and is based on the boundary GUI's shortest
		axis.

		Defaults to `UDim.new(0.05, 0)`.

	- Color3 (Color3, nil)

		Sets the color of the marker.

		Defaults to `Color3.fromRGB(242, 72, 72)`.

	- Transparency (number, nil)

		Sets the transparency of the marker.

		Defaults to 0.

	- Icon (string, nil)

		Sets an image to be displayed on the marker.

		Defaults to no image.

	- IconRect (Rect, nil)

		Sets the sprite offset and size of the icon.

		Defaults to `Rect.new(0, 0, 0, 0)`, which uses the entire image.

	- IconColor3 (Color3, nil)

		Sets the color of the icon.

		Defaults = `Color3.fromRGB(255, 255, 255)`.

#### Returns

- container (MarkerContainer)

	An object representing the container, with several methods to modify its
	behavior.

--------------------------------------------------------------------------------

### `boundary = MarkerContainer:BoundaryGUI()`

Returns the boundary GUI.

#### Returns

- boundary (GuiObject)

	The boundary GUI.

--------------------------------------------------------------------------------

### `MarkerContainer:SetBoundaryType(type, ...)`

Sets the shape of the boundary. Extra arguments depend on the type.

#### Arguments

- type (string)

	May be one of the following values:

	- "Rectangle"

		Fits the exact limits of the boundary GUI.

		This type has the following extra arguments:

		- slideType (string, nil)

			Determines how constrained markers slide along the boundary edge.
			May be one of the following values:

			- "SquareSlide": Slides in a square-like way.
			- "CircleSlide": Slides in a circular way.
			- "LerpSlide": Interpolates between SquareSlide and CircleSlide.

			Defaults to LerpSlide.

	- "Circle" (TODO)

		A circle centered on the boundary. The diameter is the size of the
		boundary's shortest axis.

	- "Ellipse" (TODO)

		An ellipse stretched to the limits of the boundary GUI.

	- "TruncatedCircle" (TODO)

		Similar to Rectangle, where the sides on one axis are round instead of
		flat.

		This type has the following extra arguments:

		- roundedAxis (string, nil)

			Determines which axis is rounded. May be one of the following
			values:

			- "X": Rounds the X axis (left and right).
			- "Y": Rounds the Y axis (top and bottom).

			Defaults to X.

	Defaults to Rectangle.

--------------------------------------------------------------------------------

### `MarkerContainer:SetEnabled(enabled)`

Sets whether markers will be displayed and updated.

When disabled, the boundary GUI will be made invisible, and the update cycle
will not be active. Consequentially, the container can be safely garbage
collected.

The container is enabled by default.

#### Arguments

- enabled (boolean)

	Whether the container is enabled.

--------------------------------------------------------------------------------

### `MarkerContainer:SetConstraintType(type)`

Specifies the behavior of markers outside the boundary.

#### Arguments

- type (string)

	May be one of the following values:

	- "Constrained": The marker is constrained to the edge of the boundary.
	- "Hidden": The marker is hidden.
	- "Unconstrained": The marker is unaffected by the boundary.

	Defaults to Constrained.

--------------------------------------------------------------------------------

### `MarkerContainer:SetArrowsEnabled(enabled)`

Sets whether a marker will display an arrow pointing to its target when the
marker is constrained. Note that this state can be overwritten per marker with
the marker's ArrowEnabled field.

Arrows are enabled by default.

#### Arguments

- enabled (boolean)

	Whether arrows are enabled.

--------------------------------------------------------------------------------

### `MarkerContainer:SetOrigin(origin)`

Sets the origin from which marker positions are determined. Marker target
positions are projected onto a Camera's 2D plane.

#### Arguments

- origin (Camera, nil)

	Determines the origin from one of a number of types:

	- Camera: Uses the Camera's CFrame.
	- nil: Uses the value of Workspace.CurrentCamera. Note that this updates
	  when the CurrentCamera changes.

--------------------------------------------------------------------------------

### `markerState = MarkerContainer:CreateMarker(initialState)`

Creates a new marker from an initial state.

#### Arguments

- initialState (table, nil)

	Each recognized field in the initial state sets the value of the
	corresponding field the marker state. If an initial value is nil, then the
	field will be set to a default instead.

#### Returns

- markerState (table)

	A table that holds the marker's state. The following fields are
	recognized:

	- Target (Vector3, CFrame, BasePart, Attachment, Model, Camera, nil)

		The position being targeted by the marker.

		- Vector3: A position in world space.
		- CFrame: Uses the CFrame's position.
		- BasePart: Uses the Position property.
		- Attachment: Uses WorldPosition property.
		- Model: Uses the PrimaryPart property. The marker will be hidden
		  while the PrimaryPart is nil.
		- nil: Hides the marker.

		Defaults to nil.

	- BodyGUI (GuiObject)

		Used as the body of the marker GUI.

		The GUI will have its Position property modified. It may also have its
		Transparency and Visible properties modified in some cases. The GUI is
		parented to the boundary GUI, and parented to nil if the marker is
		removed.

		Defaults to a basic GUI object copied from a template.

	- ArrowGUI (GuiObject)

		Used as the arrow of the marker GUI.

		The GUI will have its Rotation and Visible properties modified, and
		will be visible only if arrows are enabled. The GUI is parented to the
		body GUI, and parented to nil if the marker is removed.

		Note that a Rotation of 0 should have the arrow pointing in the
		positive X direction.

		Defaults to a basic GUI object copied from a template.

	- ArrowEnabled (boolean, nil)

		Sets whether this marker's arrow is visible. When nil, the visibility
		is determined by SetArrowsEnabled.

		Defaults to nil.

--------------------------------------------------------------------------------

### `markerStates = MarkerContainer:Markers()`

Returns a list of all the marker states in the container. Note that the order
is undefined.

#### Returns

- markerStates (table)

	A list of marker states.

--------------------------------------------------------------------------------

### `MarkerContainer:RemoveMarker(...)`

Removes one or more markers from the container. Changes made to each marker's
state will no longer be recognized, and the marker will no longer be valid for
the container.

#### Arguments

- ... (table)

	One or more marker states to be removed. Throws an error if any value is
	not a known marker state.

--------------------------------------------------------------------------------

### `MarkerContainer:RemoveAllMarkers()`

Removes all markers from the container.

--------------------------------------------------------------------------------

### `MarkerContainer:UpdateMarker(...)`

Reevaluates a marker state, forcing all changes made to the state to be
recognized. Also checks if all values in the state are valid.

#### Arguments

- ... (table)

	One or more marker states to be updated. Throws an error if any value is
	not a known marker state.

--------------------------------------------------------------------------------

]==]

local function badArgType(arg, func, expected, got, level)
	error(string.format("bad argument #%d to %s: %s expected, got %s", arg, func, expected, got), (level or 2)+1)
end

local function badFieldType(field, expected, got, level)
	error(string.format("bad field %s: %s expected, got %s", field, expected, got), (level or 2)+1)
end

local boundaryTypes = {
	Rectangle = function(slideType)
		-- Regions:
		-- \D/
		-- BXC
		-- /A\
		--
		-- 6 7 8
		-- 3 X 5
		-- 0 1 2

		-- Returns a primary and secondary point, which are used to determine
		-- the position of the sliding axis.
		local slidePoints
		-- Returns a point snapped to an edge.
		local snapMethod = function(point, slidePointA, slidePointB, edge, slide, static)
			if slide == "X" then
				return Vector2.new(slidePointA[slide], edge)
			else
				return Vector2.new(edge, slidePointA[slide])
			end
		end
		if slideType == "SquareSlide" then
			-- Choose diff-radius.
			slidePoints = function(size, diff)
				local angle = math.atan2(diff.Y, diff.X)
				local radius = diff.magnitude
				local slidePointA = Vector2.new(math.cos(angle)*radius, math.sin(angle)*radius)
				return slidePointA, Vector2.new()
			end
		elseif slideType == "CircleSlide" then
			-- Choose size-radius.
			slidePoints = function(size, diff)
				local angle = math.atan2(diff.Y, diff.X)
				local radius = (size/2).magnitude
				local slidePointA = Vector2.new(math.cos(angle)*radius, math.sin(angle)*radius)
				return slidePointA, Vector2.new()
			end
		elseif slideType == "LerpSlide" or slideType == nil then
			-- Problem: diff-radius has continuous motion as markers cross the
			-- boundary, but sliding looks ugly; size-radius has smoother
			-- sliding, but does not have continuous motion.
			--
			-- Solution: Lerp sliding coord based on distance of static coord
			-- from rectangle edge. This will yield circular sliding without
			-- sudden snapping as the edge is crossed.
			--
			-- Sliding coord: constrained between slidePointB and slidePointA.
			-- Static coord: constrained between edge and slidePointA.
			slidePoints = function(size, diff)
				local angle = math.atan2(diff.Y, diff.X)
				local radius = (size/2).magnitude
				local dradius = diff.magnitude
				local slidePointA = Vector2.new(math.cos(angle)*radius, math.sin(angle)*radius)
				local slidePointB = Vector2.new(math.cos(angle)*dradius, math.sin(angle)*dradius)
				return slidePointA, slidePointB
			end
			snapMethod = function(point, slidePointA, slidePointB, edge, slide, static)
				local mid = point[static]
				local min = edge
				local max = slidePointA[static]
				local pointDist = math.abs(mid-min)
				local maxDist = math.abs(max-min)
				local alpha = math.clamp(pointDist/maxDist, 0, 1)
				-- Lerp sliding coordinate.
				if slidePointB[slide] < slidePointA[slide] then
					min, max = slidePointB[slide], slidePointA[slide]
					mid = math.clamp((1 - alpha)*min + alpha*max, min, max)
				else
					min, max = slidePointA[slide], slidePointB[slide]
					mid = math.clamp((1 - alpha)*max + alpha*min, min, max)
				end
				if slide == "X" then
					return Vector2.new(mid, edge)
				else
					return Vector2.new(edge, mid)
				end
			end
		else
			return false, string.format("unknown slide type %q", slideType)
		end

		return true, function(rect, point)
			local size = Vector2.new(rect.Width, rect.Height)
			local a = size.Y/size.X

			local center = (rect.Min+rect.Max)/2
			local diff = point - center
			local slidePointA, slidePointB = slidePoints(size, diff)
			slidePointA, slidePointB = slidePointA + center, slidePointB + center

			local inside, snap = false, slidePointA
			if diff.Y >= diff.X*a then
				if diff.Y >= -diff.X*a then -- A
					inside = point.Y <= rect.Max.Y
					if slidePointA.X < rect.Min.X then -- 0
						snap = Vector2.new(rect.Min.X, rect.Max.Y)
					elseif slidePointA.X > rect.Max.X then -- 2
						snap = Vector2.new(rect.Max.X, rect.Max.Y)
					else -- 1
						snap = snapMethod(point, slidePointA, slidePointB, rect.Max.Y, "X", "Y")
					end
				else -- B
					inside = rect.Min.X <= point.X
					if slidePointA.Y < rect.Min.Y then -- 6
						snap = Vector2.new(rect.Min.X, rect.Min.Y)
					elseif slidePointA.Y > rect.Max.Y then -- 0
						snap = Vector2.new(rect.Min.X, rect.Max.Y)
					else -- 3
						snap = snapMethod(point, slidePointA, slidePointB, rect.Min.X, "Y", "X")
					end
				end
			else
				if diff.Y >= -diff.X*a then -- C
					inside = point.X <= rect.Max.X
					if slidePointA.Y < rect.Min.Y then -- 8
						snap = Vector2.new(rect.Max.X, rect.Min.Y)
					elseif slidePointA.Y > rect.Max.Y then -- 2
						snap = Vector2.new(rect.Max.X, rect.Max.Y)
					else -- 5
						snap = snapMethod(point, slidePointA, slidePointB, rect.Max.X, "Y", "X")
					end
				else -- D
					inside = rect.Min.Y <= point.Y
					if slidePointA.X < rect.Min.X then -- 6
						snap = Vector2.new(rect.Min.X, rect.Min.Y)
					elseif slidePointA.X > rect.Max.X then -- 8
						snap = Vector2.new(rect.Max.X, rect.Min.Y)
					else -- 7
						snap = snapMethod(point, slidePointA, slidePointB, rect.Min.Y, "X", "Y")
					end
				end
			end
			return inside, snap
		end
	end,
	Circle = function()
		return true, function(rect, point)
			return true, point
		end
	end,
	Ellipse = function()
		return true, function(rect, point)
			return true, point
		end
	end,
	TruncatedCircle = function(roundedAxis)
		return true, function(rect, point)
			return true, point
		end
	end,
}

local mtMarkerContainer = {__index={}}

function mtMarkerContainer.__index:BoundaryGUI()
	return self.boundaryGUI
end

function mtMarkerContainer.__index:SetBoundaryType(boundaryType, ...)
	if type(boundaryType) ~= "string" then
		badArgType(1, "SetBoundaryType", "string", type(boundaryType))
	end
	if boundaryType == "Rectangle" then
		if (...) ~= nil and type((...)) ~= "string" then
			badArgType(2, "SetBoundaryType", "string or nil", type((...)))
		end
	elseif boundaryType == "TruncatedCircle" then
		if (...) ~= nil and type((...)) ~= "string" then
			badArgType(2, "SetBoundaryType", "string or nil", type((...)))
		end
	end

	local boundaryType = boundaryTypes[boundaryType]
	if not boundaryType then
		error(string.format("unknown boundary type %q", boundaryType), 2)
	end

	local ok, method = boundaryType(...)
	if not ok then
		error(method, 2)
	end

	self.boundaryMethod = method
end

function mtMarkerContainer.__index:SetEnabled(enabled)
	if type(enabled) ~= "boolean" then
		badArgType(1, "SetEnabled", "boolean", type(enabled))
	end
	local prev = self.enabled
	self.enabled = enabled
	if prev ~= enabled then
		self:setUpdateCycle(enabled)
		self.boundaryGUI.Visible = enabled
	end
end

function mtMarkerContainer.__index:SetConstraintType(constraintType)
	if type(constraintType) ~= "string" then
		badArgType(1, "SetConstraintType", "string", type(constraintType))
	end
	if constraintType == "Constrained" or
		constraintType == "Hidden" or
		constraintType == "Unconstrained" then
		self.constraintType = constraintType
	else
		error(string.format("unknown constraint type %q", constraintType), 2)
	end
end

function mtMarkerContainer.__index:SetArrowsEnabled(enabled)
	if type(enabled) ~= "boolean" then
		badArgType(1, "SetArrowsEnabled", "boolean", type(enabled))
	end
	self.globalArrowsEnabled = enabled
end

function mtMarkerContainer.__index:SetOrigin(origin)
	if not (origin == nil or typeof(origin) == "Instance" and origin:IsA("Camera")) then
		badArgType(1, "SetOrigin", "classof:Camera or nil", typeof(origin))
	end
	self.camera = origin
	-- TODO: Track changes to CurrentCamera
end

local posTypeList = "Vector3, CFrame, BasePart, Attachment, Model, Camera, or nil"
local function posType(v)
	if v == nil then
		return "lua:nil"
	end
	local t = typeof(v)
	if t == "Vector3" or t == "CFrame" then
		return "rbx:"..t
	end
	if t == "Instance" then
		if v:IsA("BasePart") then
			return "classof:BasePart"
		elseif v:IsA("Attachment") then
			return "classof:Attachment"
		elseif v:IsA("Model") then
			return "classof:Model"
		elseif v:IsA("Camera") then
			return "classof:Camera"
		end
	end
	return nil
end

function mtMarkerContainer.__index:CreateMarker(initialState)
	if not (initialState == nil or type(initialState) == "table") then
		badArgType(1, "CreateMarker", "table or nil", type(initialState))
	end
	initialState = initialState or {}

	local state = {}
	if initialState.Target ~= nil then
		local targetT = posType(initialState.Target)
		if not targetT then
			badFieldType("Target", posTypeList, targetT)
		end
		state.Target = initialState.Target
	end
	if initialState.BodyGUI ~= nil then
		if not (typeof(initialState.BodyGUI) == "Instance" and initialState.BodyGUI:IsA("GuiObject")) then
			badFieldType("BodyGUI", "GuiObject", typeof(initialState.BodyGUI))
		end
		state.BodyGUI = initialState.BodyGUI
	else
		state.BodyGUI = self.bodyTemplate:Clone()
	end
	if initialState.ArrowGUI ~= nil then
		if not (typeof(initialState.ArrowGUI) == "Instance" and initialState.ArrowGUI:IsA("GuiObject")) then
			badFieldType("ArrowGUI", "GuiObject", typeof(initialState.ArrowGUI))
		end
		state.ArrowGUI = initialState.ArrowGUI
	else
		state.ArrowGUI = self.arrowTemplate:Clone()
	end
	if initialState.ArrowEnabled ~= nil then
		if type(initialState.ArrowEnabled) ~= "boolean" then
			badFieldType("ArrowEnabled", "boolean", type(initialState.ArrowEnabled))
		end
		state.ArrowEnabled = initialState.ArrowEnabled
	end
	state.ArrowGUI.Parent = state.BodyGUI
	state.BodyGUI.Parent = self.boundaryGUI
	self.markerStates[state] = true
	return state
end

function mtMarkerContainer.__index:Markers()
	local list = {}
	for state in pairs(self.markerStates) do
		list[#list+1] = state
	end
	return list
end

function mtMarkerContainer.__index:RemoveMarkers(...)
	local nargs = select("#", ...)
	local args = {...}
	local markerStates = self.markerStates
	for i = 1, nargs do
		local state = args[i]
		if not markerStates[state] then
			error(string.format("bad argument #%d: value is not a known marker state", i), 2)
		end
		markerStates[state] = nil
		if state.BodyGUI then
			state.BodyGUI.Parent = nil
		end
		if state.ArrowGUI then
			state.ArrowGUI.Parent = nil
		end
	end
end

function mtMarkerContainer.__index:RemoveAllMarkers()
	for state in pairs(self.markerStates) do
		self:RemoveMarkers(state)
	end
end

function mtMarkerContainer.__index:UpdateMarkers(...)
	local nargs = select("#", ...)
	local args = {...}
	local markerStates = self.markerStates
	for i = 1, nargs do
		local state = args[i]
		if not markerStates[state] then
			error(string.format("bad argument #%d: value is not a known marker state", i), 2)
		end
		-- TODO: Check field types.
	end
end

function mtMarkerContainer.__index:renderMarker(state, camera, position)
	if state.BodyGUI then
		local boundary = self.boundaryGUI
		local coord = camera:WorldToScreenPoint(position)
		position = Vector2.new(coord.X, coord.Y)
		local offset = boundary.AbsolutePosition
		local size = boundary.AbsoluteSize
		if coord.Z < 0 then
			position = size + offset - position + offset
		end
		if boundary.AbsoluteRotation ~= 0 then
			local angle = -math.rad(boundary.AbsoluteRotation)
			local rorigin = (size)/2
			local diff = position - offset - rorigin
			position = Vector2.new(
				diff.x*math.cos(angle) - diff.y*math.sin(angle),
				diff.x*math.sin(angle) + diff.y*math.cos(angle)
			) + rorigin + offset
		end
		if self.constraintType == "Constrained" then
			local inside, snappos = self.boundaryMethod(Rect.new(offset, offset+size), position)
			if inside and coord.Z >= 0 then
				snappos = position
			end
			state.BodyGUI.Visible = true
			local negoffset = Vector2.new(
				size.X < 0 and -size.X or 0,
				size.Y < 0 and -size.Y or 0
			)
			state.BodyGUI.Position = UDim2.new(0,snappos.X-offset.X+negoffset.X,0,snappos.Y-offset.Y+negoffset.Y)
			if state.ArrowGUI then
				local arrowsEnabled = state.ArrowEnabled
				if arrowsEnabled == nil then
					arrowsEnabled = self.globalArrowsEnabled
				end
				if arrowsEnabled then
					state.ArrowGUI.Visible = snappos ~= position
					if snappos ~= position then
						local diff = position - snappos
						local rotation = math.deg(math.atan2(diff.Y, diff.X))
						if coord.Z < 0 and inside then
							rotation = rotation + 180
						end
						state.ArrowGUI.Rotation = rotation
					end
				else
					state.ArrowGUI.Visible = false
				end
			end
		else
			if self.constraintType == "Hidden" and not self.boundaryMethod(Rect.new(offset, offset+size), position) then
				state.BodyGUI.Visible = false
			else
				if coord.Z < 0 then
					state.BodyGUI.Visible = false
				else
					state.BodyGUI.Visible = true
					state.BodyGUI.Position = UDim2.new(0,position.X-offset.X,0,position.Y-offset.Y)
				end
			end
			if state.ArrowGUI then
				state.ArrowGUI.Visible = false
			end
		end
	elseif state.ArrowGUI then
		state.ArrowGUI.Visible = false
	end
end

function mtMarkerContainer.__index:hideMarker(state)
	if state.BodyGUI then
		state.BodyGUI.Visible = false
	end
	if state.ArrowGUI then
		state.ArrowGUI.Visible = false
	end
end

function mtMarkerContainer.__index:setUpdateCycle(enabled)
	local RunService = game:GetService("RunService")
	RunService:UnbindFromRenderStep(self.id)
	if enabled then
		RunService:BindToRenderStep(self.id, Enum.RenderPriority.Camera.Value+1, function()
			local camera = self.camera
			if camera == nil then
				camera = workspace.CurrentCamera
			end
			for state in pairs(self.markerStates) do
				local position
				local targetT = typeof(state.Target)
				if targetT == "Vector3" then
					position = state.Target
				elseif targetT == "CFrame" then
					position = state.Target.p
				elseif targetT == "Instance" then
					if state.Target:IsA("BasePart") then
						position = state.Target.Position
					elseif state.Target:IsA("Attachment") then
						position = state.Target.WorldPosition
					elseif state.Target:IsA("Model") and state.Target.PrimaryPart then
						position = state.Target.PrimaryPart.Position
					end
				end
				if position then
					self:renderMarker(state, camera, position)
				else
					self:hideMarker(state)
				end
			end
		end)
	end
end

local ConstrainedMarkers = {}

local function New(boundary, enabled, defaults)
	if boundary == nil then
		boundary = Instance.new("Frame")
		boundary.Name = "MarkerBoundary"
		boundary.BackgroundTransparency = 1
		boundary.BorderSizePixel = 0
		boundary.Visible = false
		local border = 0.05
		boundary.Position = UDim2.new(border,0,border,0)
		boundary.Size = UDim2.new(1-border,0,1-border,0)
	elseif not (typeof(boundary) == "Instance" and boundary:IsA("GuiObject")) then
		badArgType(1, "New", "GuiObject", typeof(boundary))
	end
	if enabled ~= nil and type(enabled) ~= "boolean" then
		badArgType(2, "New", "boolean", type(enabled))
	end

	if not (defaults == nil or type(defaults) == "table") then
		badArgType(1, "New", "table or nil", type(defaults))
	end
	if defaults then
		if not (defaults.Size == nil or typeof(defaults.Size) == "UDim") then
			badFieldType("Size", "UDim or nil", typeof(defaults.Size))
		end
		if not (defaults.Color3 == nil or typeof(defaults.Color3) == "Color3") then
			badFieldType("Color3", "Color3 or nil", typeof(defaults.Color3))
		end
		if not (defaults.Transparency == nil or typeof(defaults.Transparency) == "number") then
			badFieldType("Transparency", "number or nil", typeof(defaults.Transparency))
		end
		if not (defaults.Icon == nil or typeof(defaults.Icon) == "string") then
			badFieldType("Icon", "string or nil", typeof(defaults.Icon))
		end
		if not (defaults.IconRect == nil or typeof(defaults.IconRect) == "Rect") then
			badFieldType("IconRect", "Rect or nil", typeof(defaults.IconRect))
		end
		if not (defaults.IconColor3 == nil or typeof(defaults.IconColor3) == "Color3") then
			badFieldType("IconColor3", "Color3 or nil", typeof(defaults.IconColor3))
		end
	else
		defaults = {}
	end
	defaults = {
		Size         = defaults.Size         == nil and UDim.new(0.05, 0)             or defaults.Size,
		Color3       = defaults.Color3       == nil and Color3.fromRGB(242, 72, 72)   or defaults.Color3,
		Transparency = defaults.Transparency == nil and 0                             or defaults.Transparency,
		Icon         = defaults.Icon         == nil and ""                            or defaults.Icon,
		IconRect     = defaults.IconRect     == nil and Rect.new(0, 0, 0, 0)          or defaults.IconRect,
		IconColor3   = defaults.IconColor3   == nil and Color3.fromRGB(255, 255, 255) or defaults.IconColor3,
	}
	local bodyTemplate do
		bodyTemplate = Instance.new("Frame")
		bodyTemplate.Name = "Marker"
		bodyTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
		bodyTemplate.BackgroundTransparency = 1
		bodyTemplate.BorderSizePixel = 0
		bodyTemplate.Size = UDim2.new(defaults.Size, defaults.Size)
		local ar = Instance.new("UIAspectRatioConstraint")
		ar.AspectRatio = 1
		ar.AspectType = Enum.AspectType.FitWithinMaxSize
		ar.DominantAxis = Enum.DominantAxis.Width
		ar.Parent = bodyTemplate
		local bg = Instance.new("ImageLabel")
		bg.Name = "Background"
		bg.BackgroundTransparency = 1
		bg.BorderSizePixel = 0
		bg.Position = UDim2.new(0, 0, 0, 0)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Image = "rbxassetid://1254529074"
		bg.ImageRectOffset = Vector2.new(1, 1)
		bg.ImageRectSize = Vector2.new(208, 208)
		bg.ImageColor3 = defaults.Color3
		bg.ImageTransparency = defaults.Transparency
		bg.Parent = bodyTemplate
		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.BackgroundTransparency = 1
		icon.BorderSizePixel = 0
		icon.Position = UDim2.new(0, 0, 0, 0)
		icon.Size = UDim2.new(1, 0, 1, 0)
		icon.Image = defaults.Icon
		icon.ImageRectOffset = defaults.IconRect.Min
		icon.ImageRectSize = Vector2.new(defaults.IconRect.Width, defaults.IconRect.Height)
		icon.ImageColor3 = defaults.IconColor3
		icon.ImageTransparency = defaults.Transparency
		icon.Parent = bodyTemplate
	end

	local arrowTemplate do
		arrowTemplate = Instance.new("Frame")
		arrowTemplate.Name = "Arrow"
		arrowTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
		arrowTemplate.BackgroundTransparency = 1
		arrowTemplate.BorderSizePixel = 0
		arrowTemplate.Position = UDim2.new(0.5, 0, 0.5, 0)
		arrowTemplate.Size = UDim2.new(1, 0, 1, 0)
		local bg = Instance.new("ImageLabel")
		bg.Name = "Background"
		bg.AnchorPoint = Vector2.new(0, 0.5)
		bg.BackgroundTransparency = 1
		bg.BorderSizePixel = 0
		bg.Position = UDim2.new(1, 0, 0.5, 0)
		bg.Size = UDim2.new(0.5, 0, 1, 0)
		bg.Image = "rbxassetid://1254529074"
		bg.ImageRectOffset = Vector2.new(210, 1)
		bg.ImageRectSize = Vector2.new(104, 208)
		bg.ImageColor3 = defaults.Color3
		bg.ImageTransparency = defaults.Transparency
		bg.Parent = arrowTemplate
	end

	local self = {
		enabled = false,
		markerStates = {},
		boundaryGUI = boundary,
		bodyTemplate = bodyTemplate,
		arrowTemplate = arrowTemplate,
		boundaryMethod = nil,
		constraintType = "Constrained",
		globalArrowsEnabled = true,
		camera = nil,
		id = nil,
	}

	-- Used as name to bind to RenderStep. Must be unique per container.
	self.id = tostring(self):match("^table: (%x+)$")
	if not self.id then
		-- Fallback in case memory address printing is removed.
		self.id = game:GetService("HttpService"):GenerateGUID(false)
	end
	self.id = "ConstrainedMarkers_" .. self.id

	self = setmetatable(self, mtMarkerContainer)
	self:SetBoundaryType("Rectangle")
	self:SetConstraintType("Constrained")
	self:SetArrowsEnabled(true)
	self:SetOrigin(nil)
	if enabled ~= false then
		self:SetEnabled(true)
	end
	return self
end

ConstrainedMarkers.New = New

return ConstrainedMarkers