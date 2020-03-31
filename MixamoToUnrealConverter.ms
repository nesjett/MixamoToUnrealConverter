/*//////////////////////////////////////
	Script developed by Nestor Sabater
	Portfolio: https://nsabater.com
	Email: contact@nsabater.com

	Download link: https://nsabater.com/mixamo-to-unreal-engine-4-bones-3ds-plugin
	
	LICENSE:
	Creative Commons: Attribution-NonCommercial-ShareAlike
	CC BY-NC-SA

//////////////////////////////////////*/

fromPrefix = "mixamorig:" -- Prefix/Suffix of mixamo bones, if any. "" (empty string if no prefix/suffix)
toPrefix = "" -- prefix/suffix you want to add to the bones. (In case you want to migrate to your own skeleton) Empty by default
fromRootBone = "Hips" -- This name must be the one of the current MIXAMO root bone when removed the prefix/suffix. CAN'T be null NOR empty
toRootBone = "root" -- Name for the new root bone that will be created. CAN'T be null NOR empty

uFromPrefix
uToPrefix
uFromRootBone
uNewRootBone

-- Bone name list to replace. Here are Unreal Engine 4 default human skeleton ones (right ones) and some of the MIXAMO.com ones (on the left)
-- WARNING: Be careful with the white spaces!
nameMap = #( \
	dataPair "Hips" "pelvis",
		
		-- RIGHT LEG
	dataPair "RightUpLeg" "thigh_r",
	dataPair "RightLeg" "calf_r",
	dataPair "RightFoot" "foot_r",
	dataPair "RightToeBase" "ball_r",
		
		-- LEFT LEG
	dataPair "LeftUpLeg" "thigh_l",
	dataPair "LeftLeg" "calf_l",
	dataPair "LeftFoot" "foot_l",
	dataPair "LeftToeBase" "ball_l",
		
		
		-- SPINE
	dataPair "Spine" "spine_01",
	dataPair "Spine1" "spine_02",
	dataPair "Spine2" "spine_03",	

		-- NECK
	dataPair "Neck" "neck_01",
	dataPair "Head" "head",

		-- RIGHT ARM
	dataPair "RightShoulder" "clavicle_r",
	dataPair "RightArm" "upperarm_r",
	dataPair "RightForearm" "lowerarm_r",	

		-- RIGHT HAND
	dataPair "RightHand" "hand_r",		
	dataPair "RightHandPinky1" "pinky_01_r",	--pinky
	dataPair "RightHandPinky2" "pinky_02_r",	
	dataPair "RightHandPinky3" "pinky_03_r",	
	dataPair "RightHandRing1" "ring_01_r",	-- ring
	dataPair "RightHandRing2" "ring_02_r",	
	dataPair "RightHandRing3" "ring_03_r",	
	dataPair "RightHandMiddle1" "middle_01_r",	-- middle
	dataPair "RightHandMiddle2" "middle_02_r",	
	dataPair "RightHandMiddle3" "middle_03_r",	
	dataPair "RightHandIndex1" "index_01_r",	 --index
	dataPair "RightHandIndex2" "index_02_r",	
	dataPair "RightHandIndex3" "index_03_r",	
	dataPair "RightHandThumb1" "thumb_01_r",	 -- thumb
	dataPair "RightHandThumb2" "thumb_02_r",	
	dataPair "RightHandThumb3" "thumb_03_r",	
		
		
		-- LEFT ARM
	dataPair "LeftShoulder" "clavicle_l",
	dataPair "LeftArm" "upperarm_l",
	dataPair "LeftForearm" "lowerarm_l",	

		-- LEFT HAND
	dataPair "LeftHand" "hand_l",		
	dataPair "LeftHandPinky1" "pinky_01_l",	--pinky
	dataPair "LeftHandPinky2" "pinky_02_l",	
	dataPair "LeftHandPinky3" "pinky_03_l",	
	dataPair "LeftHandRing1" "ring_01_l",	-- ring
	dataPair "LeftHandRing2" "ring_02_l",	
	dataPair "LeftHandRing3" "ring_03_l",	
	dataPair "LeftHandMiddle1" "middle_01_l",	-- middle
	dataPair "LeftHandMiddle2" "middle_02_l",	
	dataPair "LeftHandMiddle3" "middle_03_l",	
	dataPair "LeftHandIndex1" "index_01_l",	 --index
	dataPair "LeftHandIndex2" "index_02_l",	
	dataPair "LeftHandIndex3" "index_03_l",	
	dataPair "LeftHandThumb1" "thumb_01_l",	 -- thumb
	dataPair "LeftHandThumb2" "thumb_02_l",	
	dataPair "LeftHandThumb3" "thumb_03_l"
)


fn updateBones = ( -- This script prepares a skeleton downloaded from MIXAMO.com to match the requirements for the default UE4 humanoid skeleton.
	
	-- save parameters for UNDO if needed
	uFromPrefix = fromPrefix
	uToPrefix = toRrefix
	uFromRootBone = fromRootBone
	uNewRootBone = toRootBone
	
	
	-- Remove prefix/suffix from bones incoming from MIXAMO
	for obj in objects do ( -- parse all objects that match the pattern with the name of the object
		obj.name = substituteString obj.name fromPrefix toPrefix -- replace the strings
	)
	
	-- Create a root bone (required by UE4) in the scene center
	oldRootBone = execute ("$'"+fromRootBone + "'")
	if (oldRootBone != undefined and toRootBone != "") then (
		newRoot = Dummy() --create the root dummy
		newRoot.boxsize = [1,1,1]
		newRoot.pos = [0,0,0] -- move dummy to scene center
		newRoot.name = toRootBone -- rename newly created bone to the newRootBone provided
		oldRootBone.parent = newRoot --parent old root to new root dummy
	)
	
	
	-- Remap bone names from list (rename MIXAMO ones to UE4)
	for namePair in nameMap do ( -- check name pattern
		for obj in objects where matchPattern obj.name pattern:(namePair.v1) do ( -- parse all objects that match the pattern with the name of the object
			obj.name = namePair.v2 -- replace the strings
		)
	)
)

fn restoreBones = (
	-- Remove new root bone (required by UE4) in the scene center
	oldRootBone = execute ("$'"+ fromRootBone + "'")
	newRootBone = execute ("$'"+ toRootBone + "'")
	if (oldRootBone != undefined) then (
		oldRootBone.parent = oldRootBone --retore parent to itself
	)
	if (newRootBone != undefined) then (
		delete newRootBone --parent old root to new root dummy
	)
	
	-- Remap bone names from list (rename UE4 ones to MIXAMO)
	for namePair in nameMap do ( -- check name pattern
		for obj in objects where matchPattern obj.name pattern:(namePair.v2) do ( -- parse all objects that match the pattern with the name of the object
			obj.name = namePair.v1 -- replace the strings
		)
	)
	
	-- Remove the newly created prefix if any
	for obj in objects do ( -- parse all objects that match the pattern with the name of the object
		obj.name = substituteString obj.name toPrefix "" -- replace the strings
	)
	
	-- Set back the initial prefix
	for obj in objects do ( -- parse all objects that match the pattern with the name of the object
		if (classOf obj == Dummy) do (
			obj.name = fromPrefix+obj.name -- replace the strings
		)
	)
)

rollout gOptions "Options" width:295 height:537 (
	
	-- WrapText function borrowed from https://github.com/davestewart/maxscript/blob/master/3D/3ds2ae/03_3ds/dev/wrap%20label%20text.ms
	fn wrapText str maxW=
	(
		local strArr=#()
		local lastSpace=1
		for i = 1 to str.count do
		(
			if str[i]==" " then lastSpace=i
			local curLine=substring str 1 (lastSpace)
			local w=(getTextExtent curLine).x
			if w>maxW then
			(
				append strArr curLine
				str=substring str (curLine.count+1) str.count
			)
		)
		append strArr str
		str=""
		for s in strArr do str+=s+"\n"
		return str
	)
	
	
	label info "" align:#left  width:280 height:95
	
	on gOptions open do (
		local str = "This script renames bones to the UE4 ones (only the ones that exist in both skeletons). You can use the 'Undo' button even if no modifications have been made, this means you can fill how you want things to turn back after opening the script after having closed it, click on 'Update', and then click 'Undo' inmediatly"
		str = wrapText str 230
		info.text=str
	)
	
	
	edittext fromPrfx "Prefix/Suffix to remove:" text:fromPrefix bold:true labelOnTop:true 
	edittext toPrfx "Prefix to add:" text:toPrefix bold:true labelOnTop:true
	edittext fromRoot "Current root bone name:" text:fromRootBone bold:true labelOnTop:true
	edittext toRoot "New root bone name:" text:toRootBone bold:true labelOnTop:true
	
	button  executeBtn "Update bones" height:30
	button  undoBtn "Undo" height:30  enabled:false
	
	label feedback "" height:50
	
	label creator "Script developed by Nestor Sabater" height:20
	label creatorSite "Website"
	hyperLink website "www.nsabater.com" color:[0, 150, 255] address:"https://nsabater.com" align:#center
	
	on executeBtn pressed do	(
		undoBtn.enabled = true
		-- set params
		fromPrefix = fromPrfx.text
		toPrefix = toPrfx.text
		fromRootBone = fromRoot.text
		toRootBone = toRoot.text
		
		updateBones()
		feedback.text = "Bones Updated!"
	)
	
	on undoBtn pressed do (
		undoBtn.enabled = false
		restoreBones()
		feedback.text = "Bones restored from last changes"
	)
)

createdialog gOptions