-- local MessageLanguageIndex         = sdk.find_type_definition("via.gui.GUISystem"):get_method("get_MessageLanguage()"):call(nil)

-- Skill list
local function init()
    if Reset then
        Pl_EquipSkill_001 = false
        Pl_EquipSkill_002 = false
        Pl_EquipSkill_003 = false
        Pl_EquipSkill_004 = false
        Pl_EquipSkill_008 = false
        Pl_EquipSkill_009 = { false }
        Pl_EquipSkill_036 = false
        Pl_EquipSkill_042 = false
        Pl_EquipSkill_056 = false -- TODO
        Pl_EquipSkill_090 = false
        Pl_EquipSkill_091 = false -- TODO
        Pl_EquipSkill_102 = { false, { 0.5, 0.5, 0.7, 0.7, 0.8 } }
        Pl_EquipSkill_105 = false
        Pl_EquipSkill_204 = false
        Pl_EquipSkill_206 = false
        Pl_EquipSkill_207 = false -- TODO ?
        Pl_EquipSkill_208 = false
        Pl_EquipSkill_215 = false
        Pl_EquipSkill_220 = false -- TODO
        Pl_EquipSkill_221 = { false, { 300, 480, 720 } }
        Pl_EquipSkill_224 = false
        Pl_EquipSkill_231 = false
        Pl_EquipSkill_232 = { false, { 1800, 3600, 5400 } }
        Reset             = false
    end
end

local Pl_EquipSkill                = {}

local GUI_COMMON_MEAL_SKILL_NOTICE = 2030472943

local getSkillName                 = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
local function getChatManager()
    return sdk.get_managed_singleton("snow.gui.ChatManager")
end

local guiMessage    = sdk.find_type_definition("via.gui.message")
local getGuidByName = guiMessage:get_method("getGuidByName")
local Guid          = {}
Guid[1]             = getGuidByName:call(nil, "ChatLog_Pl_Skill_01")
Guid[2]             = getGuidByName:call(nil, "ChatLog_Pl_Skill_02")
Guid[3]             = getGuidByName:call(nil, "ChatLog_Ot_Skill_01")
Guid[4]             = getGuidByName:call(nil, "ChatLog_Ot_Skill_02")
Guid[5]             = getGuidByName:call(nil, "ChatLog_Ot_Skill_03")
Guid[6]             = getGuidByName:call(nil, "ChatLog_Co_Skill_01")
local message       = guiMessage:get_method("get(System.Guid)")


local function AddChatInfomation(skillID, isSActiveSkill)
    if isSActiveSkill then
        ChatLog = message:call(nil, Guid[1])
    elseif not isSActiveSkill then
        ChatLog = message:call(nil, Guid[2])
    end
    getChatManager():call("reqAddChatInfomation", string.gsub(ChatLog, "{0}", getSkillName(nil, skillID)), GUI_COMMON_MEAL_SKILL_NOTICE)
end

local function SkillMessage()
    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playerManager or not playerManager:call("get_RefItemParameter()") then
        init()
        return
    end

    local playerID = playerManager:call("getMasterPlayerID")

    if not playerID or playerID > 4 then
        init()
        return
    end

    local player = playerManager:get_field("PlayerListPrivate"):call("get_Item", playerID)

    if not player or not player:get_type_definition():is_a("snow.player.PlayerQuestBase") then
        init()
        return
    end

    local playerData = playerManager:call("get_PlayerData"):call("get_Item", playerID)
    local playerBase = playerManager:call("getPlayer", playerID)
    local playerSkillList = playerManager:call("get_PlayerSkill()"):call("get_Item", playerID)

    if not playerData or not playerBase or not playerSkillList then
        init()
        return
    end

    Reset = true

    for i = 1, 146 do
        Pl_EquipSkill[i] = playerSkillList:call("getSkillData", i)
    end

    -- Player
    local playerHealth                 = playerData:call("get_vital()")      -- System.Int32
    local playerMaxHealth              = player:call("getVitalMax()")        -- System.Int32
    local playerRawRedHealth           = playerData:get_field("_r_Vital")
    local playerRedHealth              = player:call("getRedVital()")        -- System.Int32

    local playerStamina                = playerData:get_field("_stamina")    -- System.Single
    local playerMaxStamina             = playerData:get_field("_staminaMax") -- System.Single

    -- Timer and State
    local _ChallengeTimer              = playerData:get_field("_ChallengeTimer")             -- System.Single
    local isDebuffState                = player:call("isDebuffState")                        -- System.Boolean
    local _PowerFreedomTimer           = playerBase:get_field("_PowerFreedomTimer")          -- System.Single
    local _WholeBodyTimer              = playerData:get_field("_WholeBodyTimer")             -- System.Single
    local _EquipSkill_036_Timer        = playerData:get_field("_EquipSkill_036_Timer")       -- System.Single
    local _SlidingPowerupTimer         = playerData:get_field("_SlidingPowerupTimer")        -- System.Single
    local _CounterattackPowerupTimer   = playerData:get_field("_CounterattackPowerupTimer")  -- System.Single
    local _DisasterTurnPowerUpTimer    = playerData:get_field("_DisasterTurnPowerUpTimer")   -- System.Single
    local _FightingSpiritTimer         = playerData:get_field("_FightingSpiritTimer")        -- System.Single
    local _EquipSkill208_AtkUpTimer    = playerData:get_field("_EquipSkill208_AtkUpTimer")   -- System.Single
    local _EquipSkill216_BottleUpTimer = player:get_field("_EquipSkill216_BottleUpTimer")    -- System.Single
    local _EquipSkill222_Timer         = playerData:get_field("_EquipSkill222_Timer")        -- System.Single
    local isHateTarget                 = player:call("isHateTarget()")                       -- System.Boolean
    local get_IsEnableEquipSkill225    = player:call("get_IsEnableEquipSkill225()")          -- System.Boolean
    local isActiveEquipSkill230        = player:call("isActiveEquipSkill230()")              -- System.Boolean
    local _EquipSkill231_WireNumTimer  = playerData:get_field("_EquipSkill231_WireNumTimer") -- System.Single
    local _EquipSkill231_WpOffTimer    = playerData:get_field("_EquipSkill231_WpOffTimer")   -- System.Single


    -- 1 Pl_EquipSkill_000 攻撃
    -- 2 Pl_EquipSkill_001 挑戦者
    if Pl_EquipSkill[2] then
        if not Pl_EquipSkill_001 and _ChallengeTimer == 180 then
            Pl_EquipSkill_001 = true
            AddChatInfomation(2, Pl_EquipSkill_001)
        elseif Pl_EquipSkill_001 and _ChallengeTimer == 0 then
            Pl_EquipSkill_001 = false
            AddChatInfomation(2, Pl_EquipSkill_001)
        end
    end
    -- 3 Pl_EquipSkill_002 フルチャージ
    if Pl_EquipSkill[3] then
        if not Pl_EquipSkill_002 and playerHealth == playerMaxHealth then
            Pl_EquipSkill_002 = true
            AddChatInfomation(3, Pl_EquipSkill_002)
        elseif Pl_EquipSkill_002 and playerHealth < playerMaxHealth then
            Pl_EquipSkill_002 = false
            AddChatInfomation(3, Pl_EquipSkill_002)
        end
    end
    -- 4 Pl_EquipSkill_003 逆恨み
    if Pl_EquipSkill[4] then
        if not Pl_EquipSkill_003 then
            if get_IsEnableEquipSkill225 or playerRedHealth > 0 then
                Pl_EquipSkill_003 = true
                AddChatInfomation(4, Pl_EquipSkill_003)
            end
        elseif Pl_EquipSkill_003 and not get_IsEnableEquipSkill225 and playerHealth == playerRawRedHealth and playerRedHealth == 0 then
            Pl_EquipSkill_003 = false
            AddChatInfomation(4, Pl_EquipSkill_003)
        end
    end
    -- 5 Pl_EquipSkill_004 死中に活
    if Pl_EquipSkill[5] then
        if not Pl_EquipSkill_004 and isDebuffState then
            Pl_EquipSkill_004 = true
            AddChatInfomation(5, Pl_EquipSkill_004)
        elseif Pl_EquipSkill_004 and not isDebuffState then
            Pl_EquipSkill_004 = false
            AddChatInfomation(5, Pl_EquipSkill_004)
        end
    end
    -- 6 Pl_EquipSkill_005 見切り
    -- 7 Pl_EquipSkill_006 超会心
    -- 8 Pl_EquipSkill_007 弱点特効
    -- 9 Pl_EquipSkill_008 力の解放
    if Pl_EquipSkill[9] then
        if not Pl_EquipSkill_008 and _PowerFreedomTimer == 7200 then
            Pl_EquipSkill_008 = true
            AddChatInfomation(9, Pl_EquipSkill_008)
        elseif Pl_EquipSkill_008 and _PowerFreedomTimer == 0 then
            Pl_EquipSkill_008 = false
            AddChatInfomation(9, Pl_EquipSkill_008)
        end
    end
    -- 10 Pl_EquipSkill_009 渾身
    if Pl_EquipSkill[10] then
        if not Pl_EquipSkill_009[2] and _WholeBodyTimer > 120 then
            Pl_EquipSkill_009[2] = true
        end
        if not Pl_EquipSkill_009[1] and Pl_EquipSkill_009[2] and playerStamina == playerMaxStamina and _WholeBodyTimer == 0 then
            Pl_EquipSkill_009[1] = true
            AddChatInfomation(10, Pl_EquipSkill_009[1])
        elseif Pl_EquipSkill_009[1] and Pl_EquipSkill_009[3] and playerStamina < playerMaxStamina and _WholeBodyTimer == 0 then
            Pl_EquipSkill_009[1] = false
            AddChatInfomation(10, Pl_EquipSkill_009[1])
            Pl_EquipSkill_009[3] = false
        elseif Pl_EquipSkill_009[1] and not Pl_EquipSkill_009[3] and playerStamina < playerMaxStamina and _WholeBodyTimer == 0 then
            Pl_EquipSkill_009[3] = true
        end
    end
    -- 11 Pl_EquipSkill_010 会心撃【属性】
    -- 12 Pl_EquipSkill_011 達人芸
    -- 13 Pl_EquipSkill_012 火属性攻撃強化
    -- 14 Pl_EquipSkill_013 水属性攻撃強化
    -- 15 Pl_EquipSkill_014 氷属性攻撃強化
    -- 16 Pl_EquipSkill_015 雷属性攻撃強化
    -- 17 Pl_EquipSkill_016 龍属性攻撃強化
    -- 18 Pl_EquipSkill_017 毒属性強化
    -- 19 Pl_EquipSkill_018 麻痺属性強化
    -- 20 Pl_EquipSkill_019 睡眠属性強化
    -- 21 Pl_EquipSkill_020 爆破属性強化
    -- 22 Pl_EquipSkill_021 匠
    -- 23 Pl_EquipSkill_022 業物
    -- 24 Pl_EquipSkill_023 弾丸節約
    -- 25 Pl_EquipSkill_024 剛刃研磨
    -- 26 Pl_EquipSkill_025 心眼
    -- 27 Pl_EquipSkill_026 弾導強化
    -- 28 Pl_EquipSkill_027 鈍器使い
    -- 29 Pl_EquipSkill_028 弓溜め段階解放
    -- 30 Pl_EquipSkill_029 集中
    -- 31 Pl_EquipSkill_030 強化持続
    -- 32 Pl_EquipSkill_031 ランナー
    -- 33 Pl_EquipSkill_032 体術
    -- 34 Pl_EquipSkill_033 スタミナ急速回復
    -- 35 Pl_EquipSkill_034 ガード性能
    -- 36 Pl_EquipSkill_035 ガード強化
    -- 37 Pl_EquipSkill_036 攻めの守勢
    if Pl_EquipSkill[37] then
        if _EquipSkill_036_Timer == 720 then
            Pl_EquipSkill_036 = true
            AddChatInfomation(37, Pl_EquipSkill_036)
        elseif Pl_EquipSkill_036 and _EquipSkill_036_Timer == 0 then
            Pl_EquipSkill_036 = false
            AddChatInfomation(37, Pl_EquipSkill_036)
        end
    end
    -- 38 Pl_EquipSkill_037 抜刀術【技】
    -- 39 Pl_EquipSkill_038 抜刀術【力】
    -- 40 Pl_EquipSkill_039 納刀術
    -- 41 Pl_EquipSkill_040 ＫＯ術
    -- 42 Pl_EquipSkill_041 スタミナ奪取
    -- 43 Pl_EquipSkill_042 滑走強化
    if Pl_EquipSkill[43] then
        if _SlidingPowerupTimer == 1800 then
            Pl_EquipSkill_042 = true
            AddChatInfomation(43, Pl_EquipSkill_042)
        elseif Pl_EquipSkill_042 and _SlidingPowerupTimer == 0 then
            Pl_EquipSkill_042 = false
            AddChatInfomation(43, Pl_EquipSkill_042)
        end
    end
    -- 44 Pl_EquipSkill_043 笛吹き名人
    -- 45 Pl_EquipSkill_044 砲術
    -- 46 Pl_EquipSkill_045 砲弾装填
    -- 47 Pl_EquipSkill_046 特殊射撃強化
    -- 48 Pl_EquipSkill_047 通常弾・連射矢強化
    -- 49 Pl_EquipSkill_048 貫通弾・貫通矢強化
    -- 50 Pl_EquipSkill_049 散弾・拡散矢強化
    -- 51 Pl_EquipSkill_050 装填拡張
    -- 52 Pl_EquipSkill_051 装填速度
    -- 53 Pl_EquipSkill_052 反動軽減
    -- 54 Pl_EquipSkill_053 ブレ抑制
    -- 55 Pl_EquipSkill_054 速射強化
    -- 56 Pl_EquipSkill_055 防御
    -- 57 Pl_EquipSkill_056 精霊の加護

    -- 58 Pl_EquipSkill_057 体力回復量ＵＰ
    -- 59 Pl_EquipSkill_058 回復速度
    -- 60 Pl_EquipSkill_059 早食い
    -- 61 Pl_EquipSkill_060 耳栓
    -- 62 Pl_EquipSkill_061 風圧耐性
    -- 63 Pl_EquipSkill_062 耐震
    -- 64 Pl_EquipSkill_063 泡沫の舞
    -- 65 Pl_EquipSkill_064 回避性能
    -- 66 Pl_EquipSkill_065 回避距離ＵＰ
    -- 67 Pl_EquipSkill_066 火耐性
    -- 68 Pl_EquipSkill_067 水耐性
    -- 69 Pl_EquipSkill_068 氷耐性
    -- 70 Pl_EquipSkill_069 雷耐性
    -- 71 Pl_EquipSkill_070 龍耐性
    -- 72 Pl_EquipSkill_071 属性やられ耐性
    -- 73 Pl_EquipSkill_072 毒耐性
    -- 74 Pl_EquipSkill_073 麻痺耐性
    -- 75 Pl_EquipSkill_074 睡眠耐性
    -- 76 Pl_EquipSkill_075 気絶耐性
    -- 77 Pl_EquipSkill_076 泥雪耐性
    -- 78 Pl_EquipSkill_077 爆破やられ耐性
    -- 79 Pl_EquipSkill_078 植生学
    -- 80 Pl_EquipSkill_079 地質学
    -- 81 Pl_EquipSkill_080 破壊王
    -- 82 Pl_EquipSkill_081 捕獲名人
    -- 83 Pl_EquipSkill_082 剥ぎ取り名人
    -- 84 Pl_EquipSkill_083 幸運
    -- 85 Pl_EquipSkill_084 砥石使用高速化
    -- 86 Pl_EquipSkill_085 ボマー
    -- 87 Pl_EquipSkill_086 キノコ大好き
    -- 88 Pl_EquipSkill_087 アイテム使用強化
    -- 89 Pl_EquipSkill_088 広域化
    -- 90 Pl_EquipSkill_089 満足感
    -- 91 Pl_EquipSkill_090 火事場力
    if Pl_EquipSkill[91] then
        if not Pl_EquipSkill_090 and playerHealth <= playerMaxHealth * 0.35 then
            Pl_EquipSkill_090 = true
            AddChatInfomation(91, Pl_EquipSkill_090)
        elseif Pl_EquipSkill_090 and playerHealth > playerMaxHealth * 0.35 then
            Pl_EquipSkill_090 = false
            AddChatInfomation(91, Pl_EquipSkill_090)
        end
    end
    -- 92 Pl_EquipSkill_091 不屈

    -- 93 Pl_EquipSkill_092 ひるみ軽減
    -- 94 Pl_EquipSkill_093 ジャンプ鉄人
    -- 95 Pl_EquipSkill_094 剥ぎ取り鉄人
    -- 96 Pl_EquipSkill_095 腹減り耐性
    -- 97 Pl_EquipSkill_096 飛び込み
    -- 98 Pl_EquipSkill_097 陽動
    -- 99 Pl_EquipSkill_098 乗り名人
    -- 100 Pl_EquipSkill_099 霞皮の恩恵
    -- 101 Pl_EquipSkill_100 鋼殻の恩恵
    -- 102 Pl_EquipSkill_101 炎鱗の恩恵
    -- 103 Pl_EquipSkill_102 龍気活性
    if Pl_EquipSkill[103] then
        if not Pl_EquipSkill_102[1] and playerHealth <= playerMaxHealth * Pl_EquipSkill_102[2][Pl_EquipSkill[103]:get_field("SkillLv")] then
            Pl_EquipSkill_102[1] = true
            AddChatInfomation(103, Pl_EquipSkill_102[1])
        elseif Pl_EquipSkill_102[1] and playerHealth > playerMaxHealth * Pl_EquipSkill_102[2][Pl_EquipSkill[103]:get_field("SkillLv")] then
            Pl_EquipSkill_102[1] = false
            AddChatInfomation(103, Pl_EquipSkill_102[1])
        end
    end
    -- 104 Pl_EquipSkill_103 翔蟲使い
    -- 105 Pl_EquipSkill_104 壁面移動
    -- 106 Pl_EquipSkill_105 逆襲
    if Pl_EquipSkill[106] then
        if _CounterattackPowerupTimer == 1800 then
            Pl_EquipSkill_105 = true
            AddChatInfomation(106, Pl_EquipSkill_105)
        elseif Pl_EquipSkill_105 and _CounterattackPowerupTimer == 0 then
            Pl_EquipSkill_105 = false
            AddChatInfomation(106, Pl_EquipSkill_105)
        end
    end
    -- 107 Pl_EquipSkill_106 高速変形
    -- 108 Pl_EquipSkill_107 鬼火纏
    -- 109 Pl_EquipSkill_108 風紋の一致
    -- 110 Pl_EquipSkill_109 雷紋の一致
    -- 111 Pl_EquipSkill_110 風雷合一
    -- 112 Pl_EquipSkill_200 血氣
    -- 113 Pl_EquipSkill_201 伏魔響命
    -- 114 Pl_EquipSkill_202 激昂
    -- 115 Pl_EquipSkill_203 業鎧【修羅】
    -- 116 Pl_EquipSkill_204 災禍転福
    if Pl_EquipSkill[116] then
        if not Pl_EquipSkill_204 and _DisasterTurnPowerUpTimer == 1800 then
            Pl_EquipSkill_204 = true
        elseif Pl_EquipSkill_204 and _DisasterTurnPowerUpTimer == 0 then
            Pl_EquipSkill_204 = false
            AddChatInfomation(116, Pl_EquipSkill_204)
        end
    end
    -- 117 Pl_EquipSkill_205 狂竜症【蝕】
    -- 118 Pl_EquipSkill_206 顕如盤石
    if Pl_EquipSkill[118] then
        if not Pl_EquipSkill_206 and _FightingSpiritTimer == 180 then
            Pl_EquipSkill_206 = true
            AddChatInfomation(118, Pl_EquipSkill_206)
        elseif Pl_EquipSkill_206 and _FightingSpiritTimer == 0 then
            Pl_EquipSkill_206 = false
            AddChatInfomation(118, Pl_EquipSkill_206)
        end
    end
    -- 119 Pl_EquipSkill_207 闇討ち

    -- 120 Pl_EquipSkill_208 巧撃
    if Pl_EquipSkill[120] then
        if _EquipSkill208_AtkUpTimer == 1800 then
            Pl_EquipSkill_208 = true
        elseif Pl_EquipSkill_208 and _EquipSkill208_AtkUpTimer == 0 then
            Pl_EquipSkill_208 = false
            AddChatInfomation(120, Pl_EquipSkill_208)
        end
    end
    -- 122 Pl_EquipSkill_209 合気
    -- 123 Pl_EquipSkill_210 供応
    -- 124 Pl_EquipSkill_211 チャージマスター
    -- 125 Pl_EquipSkill_212 攻勢
    -- 126 Pl_EquipSkill_213 チューンアップ
    -- 127 Pl_EquipSkill_214 研磨術【鋭】
    -- 128 Pl_EquipSkill_215 刃鱗磨き
    if Pl_EquipSkill[128] then
        if _EquipSkill216_BottleUpTimer == 1800 then
            Pl_EquipSkill_215 = true
        elseif Pl_EquipSkill_215 and _EquipSkill216_BottleUpTimer == 0 then
            Pl_EquipSkill_215 = false
            AddChatInfomation(128, Pl_EquipSkill_215)
        end
    end
    -- 129 Pl_EquipSkill_216 壁面移動【翔】
    -- 133 Pl_EquipSkill_217 疾之息吹
    -- 130 Pl_EquipSkill_218 弱点特効【属性】
    -- 131 Pl_EquipSkill_219 連撃
    -- 132 Pl_EquipSkill_220 根性

    -- 134 Pl_EquipSkill_221 状態異常確定蓄積
    if Pl_EquipSkill[134] then
        if _EquipSkill222_Timer == Pl_EquipSkill_221[2][Pl_EquipSkill[134]:get_field("SkillLv")] then
            Pl_EquipSkill_221[1] = true
        elseif Pl_EquipSkill_221[1] and _EquipSkill222_Timer == 0 then
            Pl_EquipSkill_221[1] = false
            AddChatInfomation(134, Pl_EquipSkill_221[1])
        end
    end
    -- 135 Pl_EquipSkill_222 剛心
    -- 136 Pl_EquipSkill_223 蓄積時攻撃強化
    -- 121 Pl_EquipSkill_224 煽衛
    if Pl_EquipSkill[121] then
        if not Pl_EquipSkill_224 and isHateTarget then
            Pl_EquipSkill_224 = true
        elseif Pl_EquipSkill_224 and not isHateTarget then
            Pl_EquipSkill_224 = false
            AddChatInfomation(121, Pl_EquipSkill_224)
        end
    end
    -- 138 Pl_EquipSkill_225 風纏
    -- 139 Pl_EquipSkill_226 粉塵纏
    -- 137 Pl_EquipSkill_227 狂化
    -- 145 Pl_EquipSkill_228 奮闘
    -- 140 Pl_EquipSkill_229 冰気錬成
    -- 141 Pl_EquipSkill_230 龍気変換
    -- 142 Pl_EquipSkill_231 天衣無崩
    if Pl_EquipSkill[142] then
        if not Pl_EquipSkill_231 and isActiveEquipSkill230 then
            Pl_EquipSkill_231 = true
        elseif Pl_EquipSkill_231 and not isActiveEquipSkill230 then
            Pl_EquipSkill_231 = false
            AddChatInfomation(142, Pl_EquipSkill_231)
        end
    end
    -- 143 Pl_EquipSkill_232 狂竜症【翔】
    if Pl_EquipSkill[143] then
        if not Pl_EquipSkill_232[1] and _EquipSkill231_WireNumTimer == Pl_EquipSkill_232[2][Pl_EquipSkill[143]:get_field("SkillLv")] then
            Pl_EquipSkill_232[1] = true
        elseif Pl_EquipSkill_232[1] and _EquipSkill231_WpOffTimer == 0 then
            Pl_EquipSkill_232[1] = false
            AddChatInfomation(143, Pl_EquipSkill_232[1])
        end
    end
    -- 146 Pl_EquipSkill_233 緩衝
end

sdk.hook(sdk.find_type_definition("snow.player.PlayerManager"):get_method("update"), function(args) ; end, SkillMessage)
