-- OP-CODE AnimatedUI Library V3 (theme manager, mobile input fixes)
-- Roblox client GUI library with animated spritesheet backgrounds
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local ContentProvider = game:GetService('ContentProvider')
local SoundService = game:GetService('SoundService')
local PlayerGui = Players.LocalPlayer:WaitForChild('PlayerGui')

local GIFs = {
 {Name='Skulls',Sheets={{77339984381359,25,3,11,256,256},{92809678980537,25,3,11,256,256},{124885789870645,25,3,9,256,256}}},
 {Name='Wave',Sheets={{97241245261849,15,8,61,128,128},{85824480192049,15,8,61,128,128}}},
 {Name='Clouds',Sheets={{14694521991,7,5,15,204,341}}},
 {Name='Fireworks',Sheets={{12430689560,15,5,45,204,113}}},
 {Name='Gold',Sheets={{14695772773,10,3,18,341,170}}},
 {Name='Matrix',Sheets={{137634279691123,15,8,61,128,128},{95334696218209,15,8,61,128,128}}},
 {Name='Blue Glitch',Sheets={{102975252620720,15,8,62,128,128}}},
 {Name='Glow Neon',Sheets={{107721861986390,25,3,14,341,205},{135169664663255,25,3,12,341,256}}},
 {Name='RY GANTENG',Sheets={{77481755047361,30,4,32,256,90},{111610672703204,30,4,32,256,90},{75249125361441,30,4,32,256,90},{85810883004608,30,4,25,256,90}}}
}

local function pos2(input)
 local p=input.Position
 return Vector2.new(p.X,p.Y)
end
local Themes = {
 Midnight={Background='#0A0A12',Header='#100E20',Sidebar='#151124',Control='#30243F',Accent='#AB52FF',Text='#F5F0FF',Muted='#C8B7D9',Border='#AB52FF',Overlay='#05050D'},
 Dark={Background='#101114',Header='#18191E',Sidebar='#1B1D22',Control='#30323B',Accent='#7F8FA8',Text='#F7F7F8',Muted='#B5BBC6',Border='#4A4D58',Overlay='#090A0C'},
 Light={Background='#F0F2F7',Header='#FFFFFF',Sidebar='#E6EAF2',Control='#DCE3EF',Accent='#5474D8',Text='#1B2436',Muted='#4C5870',Border='#B4C3E4',Overlay='#FFFFFF'},
 Ocean={Background='#071825',Header='#0C2637',Sidebar='#0C2B3F',Control='#17465A',Accent='#26B7E8',Text='#EAFBFF',Muted='#ACD5E0',Border='#26B7E8',Overlay='#041420'},
 Emerald={Background='#071812',Header='#10261D',Sidebar='#0D2B1F',Control='#20543D',Accent='#3CE3A0',Text='#E8FFF4',Muted='#A6D5C0',Border='#3CE3A0',Overlay='#05120C'},
 Crimson={Background='#1B0B10',Header='#2A1019',Sidebar='#2A121A',Control='#552332',Accent='#FF547A',Text='#FFF1F4',Muted='#E1B7C3',Border='#FF547A',Overlay='#14060A'},
 Sunset={Background='#20101F',Header='#30172D',Sidebar='#311D35',Control='#59324A',Accent='#FF9755',Text='#FFF5EE',Muted='#E8C4BB',Border='#FF9755',Overlay='#130B13'},
 Cyberpunk={Background='#070F18',Header='#0B1C28',Sidebar='#0B2230',Control='#1A3D4C',Accent='#00E5FF',Text='#E9FDFF',Muted='#9FD5E1',Border='#00E5FF',Overlay='#030A11'},
 Rose={Background='#1C101A',Header='#2C1727',Sidebar='#2D1B2B',Control='#55304D',Accent='#FF75CA',Text='#FFF1FB',Muted='#E9BCD9',Border='#FF75CA',Overlay='#110811'},
}
local function color(v)
 if typeof(v)=='Color3' then return v end
 if type(v)=='string' then
  local h=v:gsub('#','')
  if #h==6 and h:match('^%x+$') then return Color3.fromRGB(tonumber(h:sub(1,2),16),tonumber(h:sub(3,4),16),tonumber(h:sub(5,6),16)) end
 end
 return nil
end
local Library = {}
local themeHook=nil
Library.Themes = Themes
Library.Animations = GIFs
local function make(class, props, parent)
 local obj=Instance.new(class)
 for k,v in pairs(props or {}) do obj[k]=v end
 obj.Parent=parent
 return obj
end
local function corner(obj,r) make('UICorner',{CornerRadius=UDim.new(0,r or 9)},obj) end
local function label(parent,text,size)
 local l=make('TextLabel',{Size=UDim2.new(1,0,0,size or 28),BackgroundTransparency=1,Text=text or '',TextColor3=Color3.fromRGB(240,236,250),Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7},parent)
 if themeHook then themeHook(l,nil,'Text') end
 return l
end
local function btn(parent,title,height)
 local b=make('TextButton',{Size=UDim2.new(1,0,0,height or 36),BackgroundColor3=Color3.fromRGB(42,31,62),BackgroundTransparency=.12,Text=tostring(title or 'Button'),TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamMedium,TextSize=13,ZIndex=7,AutoButtonColor=true},parent)
 corner(b,8)
 if themeHook then themeHook(b,'Control','Text') end
 return b
end
local function call(fn,...)
 if type(fn)=='function' then local ok,err=pcall(fn,...) if not ok then warn('[AnimatedUI] Callback:',err) end end
end

function Library:CreateWindow(options)
 options=options or {}
 local title=options.Title or 'Animated UI'
 local guiName=options.Name or 'AnimatedUILibraryWindow'
 local old=PlayerGui:FindFirstChild(guiName)
 if old then old:Destroy() end
 if Library._windows and Library._windows[guiName] then Library._windows[guiName]:Destroy() end
 local gui=make('ScreenGui',{Name=guiName,ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},PlayerGui)
 local main=make('Frame',{Name='Main',AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=options.Size or UDim2.fromOffset(510,360),BackgroundColor3=Color3.fromRGB(10,10,18),BorderSizePixel=0,ClipsDescendants=true,ZIndex=1},gui)
 corner(main,14)
 local mainStroke=make('UIStroke',{Color=Color3.fromRGB(171,82,255),Thickness=1.5},main)
 local bg=make('ImageLabel',{Name='AnimatedBackground',Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Stretch,ImageTransparency=options.Transparency or .35,ZIndex=1},main)
 local tint=make('Frame',{Name='Tint',Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(5,5,13),BackgroundTransparency=options.OverlayTransparency or .42,BorderSizePixel=0,ZIndex=2},main)
 local header=make('Frame',{Name='Header',Size=UDim2.new(1,0,0,48),BackgroundColor3=Color3.fromRGB(10,10,20),BackgroundTransparency=.14,BorderSizePixel=0,Active=true,ZIndex=5},main)
 local ttl=make('TextLabel',{Position=UDim2.fromOffset(58,0),Size=UDim2.new(1,-155,1,0),BackgroundTransparency=1,Text=title,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=17,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},header)
 local logoImage=options.LogoImage or (options.LogoId and ('rbxassetid://'..tostring(options.LogoId)))
 local avatar=make('ImageLabel',{Name='PlayerAvatar',Position=UDim2.fromOffset(11,6),Size=UDim2.fromOffset(36,36),BackgroundColor3=Color3.fromRGB(38,30,60),Image='',ZIndex=7},header)
 corner(avatar,18)
 task.spawn(function()
  local ok,img=pcall(function()return Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)
  if ok and avatar.Parent and not logoImage then avatar.Image=img end
 end)
 local floating=make('TextButton',{Name='FloatingOpenButton',AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,18,0.5,0),Size=UDim2.fromOffset(56,56),BackgroundColor3=Color3.fromRGB(62,35,103),Text='',AutoButtonColor=true,ZIndex=30},gui)
 corner(floating,28)
 make('UIStroke',{Color=Color3.fromRGB(185,115,255),Thickness=2},floating)
 local floatIcon=make('ImageLabel',{Size=UDim2.new(1,-8,1,-8),Position=UDim2.fromOffset(4,4),BackgroundTransparency=1,Image='',ZIndex=31},floating)
 corner(floatIcon,24)
 task.spawn(function()
  local ok,img=pcall(function()return Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)
  if ok and floatIcon.Parent and not logoImage then floatIcon.Image=img end
 end)
 -- Custom logo: set LogoId to a Roblox decal/image asset or LogoImage to a local executor asset URL.
 if logoImage then
  floatIcon.Image=logoImage
  avatar.Image=logoImage
 end
 local sound=make('Sound',{Name='UIClick',SoundId=options.ClickSoundId or 'rbxassetid://140172825268473',Volume=options.SoundVolume or .28},gui)
 local soundEnabled=options.Sounds~=false
 local function clickSound()
  if soundEnabled then sound.TimePosition=0;sound:Play() end
 end
 local function bindSound(button)
  button.Activated:Connect(clickSound)
 end
 local minimize=make('TextButton',{Position=UDim2.new(1,-82,0,8),Size=UDim2.fromOffset(32,32),BackgroundColor3=Color3.fromRGB(43,35,60),Text='−',TextColor3=Color3.new(1,1,1),TextSize=20,ZIndex=7},header);corner(minimize,7)
 bindSound(minimize)
 local close=make('TextButton',{Position=UDim2.new(1,-42,0,8),Size=UDim2.fromOffset(32,32),BackgroundColor3=Color3.fromRGB(75,32,54),Text='×',TextColor3=Color3.new(1,1,1),TextSize=20,ZIndex=7},header);corner(close,7)
 bindSound(close)
 local side=make('ScrollingFrame',{Name='Sidebar',Position=UDim2.fromOffset(10,58),Size=UDim2.new(0,137,1,-68),BackgroundColor3=Color3.fromRGB(15,11,25),BackgroundTransparency=.25,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=5},main)
 corner(side,9)
 make('UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},side)
 make('UIPadding',{PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)},side)
 local content=make('Frame',{Name='Pages',Position=UDim2.fromOffset(157,58),Size=UDim2.new(1,-167,1,-68),BackgroundTransparency=1,ZIndex=5},main)
 local viewport=make('UIScale',{Scale=1},main)
 local function resize()
  local cam=workspace.CurrentCamera
  if not cam then return end
  local w,h=main.Size.X.Offset,main.Size.Y.Offset
  if w>0 and h>0 then viewport.Scale=math.min(1,(cam.ViewportSize.X-20)/w,(cam.ViewportSize.Y-20)/h) end
 end
 resize()
 local camConnection
 if workspace.CurrentCamera then camConnection=workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(resize) end
 local connections={}
 local function track(c) table.insert(connections,c) return c end
 local dragging,dragInput,dragStart,startPos=false,nil,nil,nil
 track(header.InputBegan:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   dragging=true;dragInput=input;dragStart=pos2(input);startPos=main.Position
  end
 end))
 track(UIS.InputChanged:Connect(function(input)
  if not dragging then return end
  if input==dragInput or (dragInput and dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement) then
   local d=pos2(input)-dragStart;local s=math.max(viewport.Scale,.01)
   main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X/s,startPos.Y.Scale,startPos.Y.Offset+d.Y/s)
  end
 end))
 track(UIS.InputEnded:Connect(function(input) if input==dragInput or (dragInput and dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then dragging=false end end))
 local fullSize=main.Size
 local window={Gui=gui,Main=main,Background=bg,FloatingButton=floating,CurrentAnimation=1,Playing=true,Destroyed=false}
 local themeBindings={}
 local currentTheme='Midnight'
 local customTheme=nil
 local function bindTheme(object,property,key)
  table.insert(themeBindings,{object,property,key})
 end
 local function register(obj,background,textColor)
  if background then bindTheme(obj,'BackgroundColor3',background) end
  if textColor then bindTheme(obj,'TextColor3',textColor) end
  return obj
 end
 register(main,'Background');register(header,'Header');register(side,'Sidebar');register(floating,'Accent');register(minimize,'Control','Text');register(close,'Control','Text');register(ttl,nil,'Text')
 register(avatar,'Control')
 bindTheme(mainStroke,'Color','Border');bindTheme(tint,'BackgroundColor3','Overlay')
 -- Logo images retain their original colors.
 themeHook=register
 local function palette()
  local base=Themes[currentTheme] or Themes.Midnight
  local t={}
  for k,v in pairs(base) do t[k]=color(v) or v end
  if customTheme then for k,v in pairs(customTheme) do local c=color(v);if c then t[k]=c end end end
  return t
 end
 local function applyTheme()
  local t=palette()
  for _,b in ipairs(themeBindings) do
   local obj,prop,key=b[1],b[2],b[3]
   if obj and obj.Parent and t[key] then obj[prop]=t[key] end
  end
  if window._activeButton and window._activeButton.Parent then window._activeButton.BackgroundColor3=t.Accent end
 end
 function window:SetTheme(name)
  if not Themes[name] then return false end
  currentTheme=name;customTheme=nil;applyTheme();return true
 end
 function window:SetCustomTheme(values)
  if type(values)~='table' then return false end
  customTheme=values;applyTheme();return true
 end
 function window:GetTheme()return currentTheme end
 function window:GetThemes()
  local names={}
  for name in pairs(Themes) do table.insert(names,name) end
  table.sort(names);return names
 end
 Library._windows=Library._windows or {}
 Library._windows[guiName]=window
 local floatMoved=false
 local floatDragging=false
 local floatStart,floatPosition,floatInput
 track(floating.InputBegan:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   floatDragging=true;floatMoved=false;floatStart=pos2(input);floatPosition=floating.Position;floatInput=input
  end
 end))
 track(UIS.InputChanged:Connect(function(input)
  if floatDragging and (input==floatInput or (floatInput and floatInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then
   local d=pos2(input)-floatStart
   if d.Magnitude>12 then floatMoved=true end
   floating.Position=UDim2.new(floatPosition.X.Scale,floatPosition.X.Offset+d.X,floatPosition.Y.Scale,floatPosition.Y.Offset+d.Y)
  end
 end))
 track(UIS.InputEnded:Connect(function(input)
  if input==floatInput then floatDragging=false end
 end))
 track(floating.Activated:Connect(function()
  if floatMoved then floatMoved=false;return end
  main.Visible=not main.Visible
  clickSound()
 end))
 function window:SetSounds(value) soundEnabled=not not value end
 function window:SetClickSound(assetId)
  sound.SoundId=tostring(assetId):find('rbxassetid://',1,true) and tostring(assetId) or 'rbxassetid://'..tostring(assetId)
 end
 function window:SetTitle(value) ttl.Text=tostring(value) end
 function window:SetLogo(image)
  local asset=tostring(image or '')
  if asset:match('^%d+$') then asset='rbxassetid://'..asset end
  avatar.Image=asset;floatIcon.Image=asset
 end
 function window:SetVisible(value) main.Visible=not not value end
 function window:SetSize(width,height)
  width=math.clamp(tonumber(width) or 510,350,900)
  height=math.clamp(tonumber(height) or 360,250,700)
  fullSize=UDim2.fromOffset(width,height)
  main.Size=fullSize
  resize()
 end
 local current=1;local playing=true;local frozen=0;local started=os.clock();local lastSheet,lastFrame=nil,-1
 function window:SetAnimation(name)
  local idx=tonumber(name)
  if not idx then for i,g in ipairs(GIFs) do if g.Name:lower()==tostring(name):lower() then idx=i;break end end end
  if not idx then return false end
  current=(idx-1)%#GIFs+1;self.CurrentAnimation=current;frozen=0;started=os.clock();lastSheet=nil;lastFrame=-1;return true
 end
 function window:SetTransparency(v) bg.ImageTransparency=math.clamp(tonumber(v) or .35,0,1) end
 function window:SetPlaying(v)
  v=not not v
  if v==playing then return end
  if not v then frozen=frozen+(os.clock()-started) else started=os.clock() end
  playing=v;self.Playing=v
 end
 function window:Toggle() main.Visible=not main.Visible end
 local minimized=false
 function window:Minimize(value)
  minimized=value==nil and not minimized or not not value
  side.Visible=not minimized;content.Visible=not minimized
  TweenService:Create(main,TweenInfo.new(.2),{Size=minimized and UDim2.fromOffset(fullSize.X.Offset,48) or fullSize}):Play()
 end
 track(minimize.MouseButton1Click:Connect(function()
  window:Minimize()
 end))
 local activeTab
 function window:CreateTab(opts)
  opts=type(opts)=='string' and {Title=opts} or (opts or {})
  local name=opts.Title or 'Tab'
  local tabButton=btn(side,name,34)
  bindTheme(tabButton,'BackgroundColor3','Control')
  bindSound(tabButton)
  local page=make('ScrollingFrame',{Name=name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,ZIndex=6},content)
  make('UIListLayout',{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
  make('UIPadding',{PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,8)},page)
  local function selectTab()
   if activeTab then activeTab.Page.Visible=false;activeTab.Button.BackgroundColor3=palette().Control end
   page.Visible=true;tabButton.BackgroundColor3=palette().Accent;activeTab={Page=page,Button=tabButton};window._activeButton=tabButton
  end
  track(tabButton.MouseButton1Click:Connect(selectTab))
  if not activeTab then selectTab() end
  local tab={Page=page}
  function tab:Section(x)
   local t=type(x)=='table' and x.Title or x
   local l=label(page,tostring(t or 'Section'),28);l.Font=Enum.Font.GothamBold;bindTheme(l,'TextColor3','Accent');return l
  end
  function tab:Label(x)
   local t=type(x)=='table' and (x.Text or x.Title) or x
   return label(page,tostring(t or ''),28)
  end
  function tab:Button(x)
   x=type(x)=='string' and {Title=x} or (x or {})
   local b=btn(page,x.Title or 'Button')
   bindSound(b)
   track(b.MouseButton1Click:Connect(function()call(x.Callback)end))
   applyTheme()
   return b
  end
  function tab:Toggle(x)
   x=x or {};local value=x.Value==true
   local b=btn(page,'',36)
   local function refresh()b.Text=(value and '●  ' or '○  ')..(x.Title or 'Toggle') end
   refresh()
   bindSound(b)
   track(b.MouseButton1Click:Connect(function()value=not value;refresh();call(x.Callback,value)end))
   applyTheme()
   return {Set=function(_,v)value=not not v;refresh();call(x.Callback,value)end,Get=function()return value end}
  end
  function tab:Slider(x)
   x=x or {};local v=x.Value or {};local lo=tonumber(x.Min or v.Min) or 0;local hi=tonumber(x.Max or v.Max) or 100
   if hi<=lo then hi=lo+1 end
   local step=math.max(tonumber(x.Step) or 1,.0001)
   local value=math.clamp(tonumber(x.Default or v.Default) or lo,lo,hi)
   local holder=make('Frame',{Size=UDim2.new(1,0,0,57),BackgroundColor3=Color3.fromRGB(42,31,62),BackgroundTransparency=.12,BorderSizePixel=0,ZIndex=7},page);corner(holder,8);register(holder,'Control')
   local textLabel=label(holder,'',26);textLabel.Position=UDim2.fromOffset(10,0);textLabel.Size=UDim2.new(1,-20,0,26)
   local trackBar=make('Frame',{Position=UDim2.new(0,10,0,37),Size=UDim2.new(1,-20,0,7),BackgroundColor3=Color3.fromRGB(24,18,34),BorderSizePixel=0,ZIndex=8},holder);corner(trackBar,4)
   local fill=make('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=Color3.fromRGB(169,81,255),BorderSizePixel=0,ZIndex=9},trackBar);corner(fill,4);register(fill,'Accent')
   local function set(vv,notify)
    value=math.clamp(math.floor((vv-lo)/step+.5)*step+lo,lo,hi)
    textLabel.Text=(x.Title or 'Slider')..': '..string.format('%g',value)
    fill.Size=UDim2.fromScale((value-lo)/(hi-lo),1)
    if notify then call(x.Callback,value) end
   end
   set(value,false)
   applyTheme()
   local sliding=false
   local function fromInput(input)
    if trackBar.AbsoluteSize.X<=0 then return end
    local alpha=math.clamp((pos2(input).X-trackBar.AbsolutePosition.X)/trackBar.AbsoluteSize.X,0,1)
    set(lo+(hi-lo)*alpha,true)
   end
   track(holder.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=true;fromInput(input) end
   end))
   track(UIS.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then fromInput(input) end
   end))
   track(UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=false end
   end))
   return {Set=function(_,v2)set(
