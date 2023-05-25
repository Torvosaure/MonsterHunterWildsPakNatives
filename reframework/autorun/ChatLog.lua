local Pl
local Ed
local Kd
local St
local Reset

local function getPlayerManager()
    return sdk.get_managed_singleton("snow.player.PlayerManager")
end
local function getMasterPlayerID()
    return getPlayerManager():call("getMasterPlayerID")
end
local function getPlayerListPrivate()
    return getPlayerManager():get_field("PlayerListPrivate"):call("get_Item", getMasterPlayerID())
end
local function getPlayerData()
    return getPlayerManager():call("get_PlayerData"):call("get_Item", getMasterPlayerID())
end
local function getPlayer()
    return getPlayerManager():call("getPlayer", getMasterPlayerID())
end
local function getPlayerSkill()
    return getPlayerManager():call("get_PlayerSkill()"):call("get_Item", getMasterPlayerID())
end

local function init()
    Reset                       = true
    local _EquipSkillParameter  = getPlayerManager():get_field("_PlayerUserDataSkillParameter"):get_field("_EquipSkillParameter")
    local _OdangoSkillParameter = getPlayerManager():get_field("_PlayerUserDataSkillParameter"):get_field("_OdangoSkillParameter")
    return {
        EquipSkill_001   = false,
        EquipSkill_002   = false,
        EquipSkill_003   = false,
        EquipSkill_004   = false,
        EquipSkill_008   = false,
        EquipSkill_009   = { false },
        EquipSkill_036   = false,
        EquipSkill_042   = { false, _EquipSkillParameter:get_field("_EquipSkill_042_CtlAddTime") },
        EquipSkill_090   = false,
        EquipSkill_091   = { false, 0 },
        EquipSkill_102   = { false, { 0.5, 0.5, 0.7, 0.7, 0.8 } },
        EquipSkill_105   = false,
        EquipSkill_204   = false,
        EquipSkill_206   = false,
        EquipSkill_208   = false,
        EquipSkill_215   = false,
        EquipSkill_220   = false,
        EquipSkill_221   = { false, { 300, 480, 720 } },
        EquipSkill_222   = { false, { 0.5, 0.3 }, _EquipSkillParameter:get_field("_EquipSkill_223"):get_field("_AccumulatorMax") },
        EquipSkill_224   = false,
        EquipSkill_231   = false,
        EquipSkill_232   = { false, { 1800, 3600, 5400 } },

        KitchenSkill_002 = {
            false,
            {
                _OdangoSkillParameter:get_field("_KitchenSkill_002_Lv1"):get_field("_EnableHP"),
                _OdangoSkillParameter:get_field("_KitchenSkill_002_Lv2"):get_field("_EnableHP"),
                _OdangoSkillParameter:get_field("_KitchenSkill_002_Lv3"):get_field("_EnableHP"),
                _OdangoSkillParameter:get_field("_KitchenSkill_002_Lv4"):get_field("_EnableHP")
            }
        },
        KitchenSkill_024 = false,
        KitchenSkill_027 = {
            false,
            {
                _OdangoSkillParameter:get_field("_KitchenSkill_027_Lv1"):get_field("_Time"),
                _OdangoSkillParameter:get_field("_KitchenSkill_027_Lv2"):get_field("_Time"),
                _OdangoSkillParameter:get_field("_KitchenSkill_027_Lv3"):get_field("_Time"),
                _OdangoSkillParameter:get_field("_KitchenSkill_027_Lv4"):get_field("_Time")
            }
        },
        KitchenSkill_048 = {
            false,
            {
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv1_Damage"),
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv2_Damage"),
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv3_Damage"),
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv4_Damage")
            },
            {
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv1_Reduce"),
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv2_Reduce"),
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv3_Reduce"),
                _OdangoSkillParameter:get_field("_KitchenSkill_048_Lv4_Reduce")
            }
        }
    }
end

local function getState()
    local player     = getPlayerListPrivate()
    local playerData = getPlayerData()
    local playerBase = getPlayer()
    return {
        playerHealth                 = playerData:call("get_vital()"),
        playerMaxHealth              = player:call("getVitalMax()"),
        playerRawRedHealth           = playerData:get_field("_r_Vital"),
        playerRedHealth              = player:call("getRedVital()"),
        playerStamina                = playerData:get_field("_stamina"),
        playerMaxStamina             = playerData:get_field("_staminaMax"),

        -- Timer etc.
        _ChallengeTimer              = playerData:get_field("_ChallengeTimer"),
        isDebuffState                = player:call("isDebuffState"),
        _PowerFreedomTimer           = playerBase:get_field("_PowerFreedomTimer"),
        _WholeBodyTimer              = playerData:get_field("_WholeBodyTimer"),
        _EquipSkill_036_Timer        = playerData:get_field("_EquipSkill_036_Timer"),
        _SlidingPowerupTimer         = playerData:get_field("_SlidingPowerupTimer"),
        isEquipSkill091              = playerBase:call("isEquipSkill091()"),
        _DieCount                    = playerData:get_field("_DieCount"),
        _CounterattackPowerupTimer   = playerData:get_field("_CounterattackPowerupTimer"),
        _DisasterTurnPowerUpTimer    = playerData:get_field("_DisasterTurnPowerUpTimer"),
        _FightingSpiritTimer         = playerData:get_field("_FightingSpiritTimer"),
        _EquipSkill208_AtkUpTimer    = playerData:get_field("_EquipSkill208_AtkUpTimer"),
        _EquipSkill216_BottleUpTimer = player:get_field("_EquipSkill216_BottleUpTimer"),
        isHaveSkillGuts              = sdk.get_managed_singleton("snow.gui.GuiManager"):get_field("<refGuiHud>k__BackingField"):get_field("PlayerInfo"):get_field("isHaveSkillGuts"),
        _EquipSkill222_Timer         = playerData:get_field("_EquipSkill222_Timer"),
        _EquipSkill223Accumulator    = playerData:get_field("_EquipSkill223Accumulator"),
        isHateTarget                 = player:call("isHateTarget()"),
        get_IsEnableEquipSkill225    = player:call("get_IsEnableEquipSkill225()"),
        isActiveEquipSkill230        = player:call("isActiveEquipSkill230()"),
        _EquipSkill231_WireNumTimer  = playerData:get_field("_EquipSkill231_WireNumTimer"),
        _EquipSkill231_WpOffTimer    = playerData:get_field("_EquipSkill231_WpOffTimer"),

        isHaveKitchenGuts            = sdk.get_managed_singleton("snow.gui.GuiManager"):get_field("<refGuiHud>k__BackingField"):get_field("PlayerInfo"):get_field("isHaveKitchenGuts"),
        _KitchenSkill027Timer        = playerData:get_field("_KitchenSkill027Timer"),
        _HornMusicDamageReduce       = playerData:get_field("_HornMusicDamageReduce"),
        _KitchenSkill048_Damage      = playerData:get_field("_KitchenSkill048_Damage")
    }
end

local function getSkillData()
    local Ed = { EquipSkill = {} }
    for i = 1, 146 do
        Ed.EquipSkill[i] = getPlayerSkill():call("getSkillData", i)
    end
    return Ed
end
local function getKitchenSkillData()
    local Kd = { KitchenSkill = {} }
    for i = 1, 56 do
        Kd.KitchenSkill[i] = getPlayerSkill():call("getKitchenSkillData", i)
    end
    return Kd
end

local function getChatManager()
    return sdk.get_managed_singleton("snow.gui.ChatManager")
end

local getGuidByName = sdk.find_type_definition("via.gui.message"):get_method("getGuidByName")
local message       = sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)")
local function getMessageByName(Name)
    local Guid = getGuidByName:call(nil, Name)
    return message:call(nil, Guid)
end
-- ChatLog_Pl_Skill_01
-- ChatLog_Pl_Skill_02
-- ChatLog_Ot_Skill_01
-- ChatLog_Ot_Skill_02
-- ChatLog_Ot_Skill_03
-- ChatLog_Co_Skill_01

local getEquipSkillName            = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
local getKitchenSkillName          = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlKitchenSkillId)")
local GUI_COMMON_MEAL_SKILL_NOTICE = 2030472943
local function AddChatInfomation(type, skillID, isSkillActive)
    local getName
    if type == 1 then
        getName = getEquipSkillName
    elseif type == 2 then
        getName = getKitchenSkillName
    elseif type == 3 then
        getName = nil
    end
    if isSkillActive then
        ChatLog = getMessageByName("ChatLog_Pl_Skill_01")
    elseif not isSkillActive then
        ChatLog = getMessageByName("ChatLog_Pl_Skill_02")
    end
    getChatManager():call("reqAddChatInfomation", string.gsub(ChatLog, "{0}", getName(nil, skillID)), GUI_COMMON_MEAL_SKILL_NOTICE)
end

local function update()
    local playerManager = getPlayerManager()
    if not playerManager or not playerManager:call("get_RefItemParameter()") then
        if not Reset then Pl = init() end
        return
    end

    local playerID = getMasterPlayerID()
    if not playerID or playerID > 4 then
        if not Reset then Pl = init() end
        return
    end

    local player = getPlayerListPrivate()
    if not player or not player:get_type_definition():is_a("snow.player.PlayerQuestBase") then
        if not Reset then Pl = init() end
        return
    end

    local playerData      = getPlayerData()
    local playerBase      = getPlayer()
    local playerSkillList = getPlayerSkill()
    if not playerData or not playerBase or not playerSkillList then
        if not Reset then Pl = init() end
        return
    end

    if not Pl then Pl = init() end
    Ed = getSkillData()
    Kd = getKitchenSkillData()
    St = getState()

    Reset = false

    -- 1 Pl_EquipSkill_000 攻撃
    -- 2 Pl_EquipSkill_001 挑戦者
    if Ed.EquipSkill[2] then
        if not Pl.EquipSkill_001 and St._ChallengeTimer == 180 then
            Pl.EquipSkill_001 = true
            AddChatInfomation(1, 2, Pl.EquipSkill_001)
        elseif Pl.EquipSkill_001 and St._ChallengeTimer == 0 then
            Pl.EquipSkill_001 = false
            AddChatInfomation(1, 2, Pl.EquipSkill_001)
        end
    end
    -- 3 Pl_EquipSkill_002 フルチャージ
    if Ed.EquipSkill[3] then
        if not Pl.EquipSkill_002 and St.playerHealth == St.playerMaxHealth then
            Pl.EquipSkill_002 = true
            AddChatInfomation(1, 3, Pl.EquipSkill_002)
        elseif Pl.EquipSkill_002 and St.playerHealth < St.playerMaxHealth then
            Pl.EquipSkill_002 = false
            AddChatInfomation(1, 3, Pl.EquipSkill_002)
        end
    end
    -- 4 Pl_EquipSkill_003 逆恨み
    if Ed.EquipSkill[4] then
        if not Pl.EquipSkill_003 then
            if St.get_IsEnableEquipSkill225 or St.playerRedHealth > 0 then
                Pl.EquipSkill_003 = true
                AddChatInfomation(1, 4, Pl.EquipSkill_003)
            end
        elseif Pl.EquipSkill_003 and not St.get_IsEnableEquipSkill225 and St.playerHealth == St.playerRawRedHealth and St.playerRedHealth == 0 then
            Pl.EquipSkill_003 = false
            AddChatInfomation(1, 4, Pl.EquipSkill_003)
        end
    end
    -- 5 Pl_EquipSkill_004 死中に活
    if Ed.EquipSkill[5] then
        if not Pl.EquipSkill_004 and St.isDebuffState then
            Pl.EquipSkill_004 = true
            AddChatInfomation(1, 5, Pl.EquipSkill_004)
        elseif Pl.EquipSkill_004 and not St.isDebuffState then
            Pl.EquipSkill_004 = false
            AddChatInfomation(1, 5, Pl.EquipSkill_004)
        end
    end
    -- 6 Pl_EquipSkill_005 見切り
    -- 7 Pl_EquipSkill_006 超会心
    -- 8 Pl_EquipSkill_007 弱点特効
    -- 9 Pl_EquipSkill_008 力の解放
    if Ed.EquipSkill[9] then
        if not Pl.EquipSkill_008 and St._PowerFreedomTimer == 7200 then
            Pl.EquipSkill_008 = true
            AddChatInfomation(1, 9, Pl.EquipSkill_008)
        elseif Pl.EquipSkill_008 and St._PowerFreedomTimer == 0 then
            Pl.EquipSkill_008 = false
            AddChatInfomation(1, 9, Pl.EquipSkill_008)
        end
    end
    -- 10 Pl_EquipSkill_009 渾身
    if Ed.EquipSkill[10] then
        if not Pl.EquipSkill_009[2] and St._WholeBodyTimer > 120 then
            Pl.EquipSkill_009[2] = true
        end
        if not Pl.EquipSkill_009[1] and Pl.EquipSkill_009[2] and St.playerStamina == St.playerMaxStamina and St._WholeBodyTimer == 0 then
            Pl.EquipSkill_009[1] = true
            AddChatInfomation(1, 10, Pl.EquipSkill_009[1])
        elseif Pl.EquipSkill_009[1] and Pl.EquipSkill_009[3] and St.playerStamina < St.playerMaxStamina and St._WholeBodyTimer == 0 then
            Pl.EquipSkill_009[1] = false
            AddChatInfomation(1, 10, Pl.EquipSkill_009[1])
            Pl.EquipSkill_009[3] = false
        elseif Pl.EquipSkill_009[1] and not Pl.EquipSkill_009[3] and St.playerStamina < St.playerMaxStamina and St._WholeBodyTimer == 0 then
            Pl.EquipSkill_009[3] = true
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
    if Ed.EquipSkill[37] then
        if St._EquipSkill_036_Timer == 720 then
            Pl.EquipSkill_036 = true
            AddChatInfomation(1, 37, Pl.EquipSkill_036)
        elseif Pl.EquipSkill_036 and St._EquipSkill_036_Timer == 0 then
            Pl.EquipSkill_036 = false
            AddChatInfomation(1, 37, Pl.EquipSkill_036)
        end
    end
    -- 38 Pl_EquipSkill_037 抜刀術【技】
    -- 39 Pl_EquipSkill_038 抜刀術【力】
    -- 40 Pl_EquipSkill_039 納刀術
    -- 41 Pl_EquipSkill_040 ＫＯ術
    -- 42 Pl_EquipSkill_041 スタミナ奪取
    -- 43 Pl_EquipSkill_042 滑走強化
    if Ed.EquipSkill[43] then
        if not Pl.EquipSkill_042[1] and St._SlidingPowerupTimer == Pl.EquipSkill_042[2] * 60 then
            Pl.EquipSkill_042[1] = true
            AddChatInfomation(1, 43, Pl.EquipSkill_042[1])
        elseif Pl.EquipSkill_042[1] and St._SlidingPowerupTimer == 0 then
            Pl.EquipSkill_042[1] = false
            AddChatInfomation(1, 43, Pl.EquipSkill_042[1])
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
    if Ed.EquipSkill[91] then
        if not Pl.EquipSkill_090 and St.playerHealth <= St.playerMaxHealth * 0.35 then
            Pl.EquipSkill_090 = true
            AddChatInfomation(1, 91, Pl.EquipSkill_090)
        elseif Pl.EquipSkill_090 and St.playerHealth > St.playerMaxHealth * 0.35 then
            Pl.EquipSkill_090 = false
            AddChatInfomation(1, 91, Pl.EquipSkill_090)
        end
    end
    -- 92 Pl_EquipSkill_091 不屈
    if St.isEquipSkill091 then
        if Ed.EquipSkill[92] then
            if St._DieCount - Pl.EquipSkill_091[2] > 0 or (St._DieCount > 0 and not Pl.EquipSkill_091[1]) then
                Pl.EquipSkill_091[2] = St._DieCount
                Pl.EquipSkill_091[1] = true
                AddChatInfomation(1, 92, Pl.EquipSkill_091[1])
            elseif Pl.EquipSkill_091[1] and St._DieCount - Pl.EquipSkill_091[2] < 0 then
                Pl.EquipSkill_091[1] = false
                AddChatInfomation(1, 92, Pl.EquipSkill_091[1])
            end
        elseif not Ed.EquipSkill[92] and Pl.EquipSkill_091[1] then
            Pl.EquipSkill_091[1] = false
            AddChatInfomation(1, 92, Pl.EquipSkill_091[1])
        end
    end
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
    if Ed.EquipSkill[103] then
        if not Pl.EquipSkill_102[1] and St.playerHealth <= St.playerMaxHealth * Pl.EquipSkill_102[2][Ed.EquipSkill[103]:get_field("SkillLv")] then
            Pl.EquipSkill_102[1] = true
            AddChatInfomation(1, 103, Pl.EquipSkill_102[1])
        elseif Pl.EquipSkill_102[1] and St.playerHealth > St.playerMaxHealth * Pl.EquipSkill_102[2][Ed.EquipSkill[103]:get_field("SkillLv")] then
            Pl.EquipSkill_102[1] = false
            AddChatInfomation(1, 103, Pl.EquipSkill_102[1])
        end
    end
    -- 104 Pl_EquipSkill_103 翔蟲使い
    -- 105 Pl_EquipSkill_104 壁面移動
    -- 106 Pl_EquipSkill_105 逆襲
    if Ed.EquipSkill[106] then
        if St._CounterattackPowerupTimer == 1800 then
            Pl.EquipSkill_105 = true
            AddChatInfomation(1, 106, Pl.EquipSkill_105)
        elseif Pl.EquipSkill_105 and St._CounterattackPowerupTimer == 0 then
            Pl.EquipSkill_105 = false
            AddChatInfomation(1, 106, Pl.EquipSkill_105)
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
    if Ed.EquipSkill[116] then
        if not Pl.EquipSkill_204 and St._DisasterTurnPowerUpTimer == 1800 then
            Pl.EquipSkill_204 = true
        elseif Pl.EquipSkill_204 and St._DisasterTurnPowerUpTimer == 0 then
            Pl.EquipSkill_204 = false
            AddChatInfomation(1, 116, Pl.EquipSkill_204)
        end
    end
    -- 117 Pl_EquipSkill_205 狂竜症【蝕】
    -- 118 Pl_EquipSkill_206 顕如盤石
    if Ed.EquipSkill[118] then
        if not Pl.EquipSkill_206 and St._FightingSpiritTimer == 180 then
            Pl.EquipSkill_206 = true
            AddChatInfomation(1, 118, Pl.EquipSkill_206)
        elseif Pl.EquipSkill_206 and St._FightingSpiritTimer == 0 then
            Pl.EquipSkill_206 = false
            AddChatInfomation(1, 118, Pl.EquipSkill_206)
        end
    end
    -- 119 Pl_EquipSkill_207 闇討ち
    -- 120 Pl_EquipSkill_208 巧撃
    if Ed.EquipSkill[120] then
        if St._EquipSkill208_AtkUpTimer == 1800 then
            Pl.EquipSkill_208 = true
        elseif Pl.EquipSkill_208 and St._EquipSkill208_AtkUpTimer == 0 then
            Pl.EquipSkill_208 = false
            AddChatInfomation(1, 120, Pl.EquipSkill_208)
        end
    end
    -- 122 Pl_EquipSkill_209 合気
    -- 123 Pl_EquipSkill_210 供応
    -- 124 Pl_EquipSkill_211 チャージマスター
    -- 125 Pl_EquipSkill_212 攻勢
    -- 126 Pl_EquipSkill_213 チューンアップ
    -- 127 Pl_EquipSkill_214 研磨術【鋭】
    -- 128 Pl_EquipSkill_215 刃鱗磨き
    if Ed.EquipSkill[128] then
        if St._EquipSkill216_BottleUpTimer == 1800 then
            Pl.EquipSkill_215 = true
        elseif Pl.EquipSkill_215 and St._EquipSkill216_BottleUpTimer == 0 then
            Pl.EquipSkill_215 = false
            AddChatInfomation(1, 128, Pl.EquipSkill_215)
        end
    end
    -- 129 Pl_EquipSkill_216 壁面移動【翔】
    -- 133 Pl_EquipSkill_217 疾之息吹
    -- 130 Pl_EquipSkill_218 弱点特効【属性】
    -- 131 Pl_EquipSkill_219 連撃
    -- 132 Pl_EquipSkill_220 根性
    if Ed.EquipSkill[132] and not Pl.EquipSkill_220 and St.isHaveSkillGuts then
        Pl.EquipSkill_220 = true
    elseif not Ed.EquipSkill[132] and Pl.EquipSkill_220 and not St.isHaveSkillGuts then
        AddChatInfomation(1, 132, Pl.EquipSkill_220)
        Pl.EquipSkill_220 = false
    end
    -- 134 Pl_EquipSkill_221 状態異常確定蓄積
    if Ed.EquipSkill[134] then
        if St._EquipSkill222_Timer == Pl.EquipSkill_221[2][Ed.EquipSkill[134]:get_field("SkillLv")] then
            Pl.EquipSkill_221[1] = true
        elseif Pl.EquipSkill_221[1] and St._EquipSkill222_Timer == 0 then
            Pl.EquipSkill_221[1] = false
            AddChatInfomation(1, 134, Pl.EquipSkill_221[1])
        end
    end
    -- 135 Pl_EquipSkill_222 剛心
    if Ed.EquipSkill[135] then
        if St._EquipSkill223Accumulator == Pl.EquipSkill_222[3] then
            Pl.EquipSkill_222[1] = true
        end
    end
    -- 136 Pl_EquipSkill_223 蓄積時攻撃強化
    -- 121 Pl_EquipSkill_224 煽衛
    if Ed.EquipSkill[121] then
        if not Pl.EquipSkill_224 and St.isHateTarget then
            Pl.EquipSkill_224 = true
        elseif Pl.EquipSkill_224 and not St.isHateTarget then
            Pl.EquipSkill_224 = false
            AddChatInfomation(1, 121, Pl.EquipSkill_224)
        end
    end
    -- 138 Pl_EquipSkill_225 風纏
    -- 139 Pl_EquipSkill_226 粉塵纏
    -- 137 Pl_EquipSkill_227 狂化
    -- 145 Pl_EquipSkill_228 奮闘
    -- 140 Pl_EquipSkill_229 冰気錬成
    -- 141 Pl_EquipSkill_230 龍気変換
    -- 142 Pl_EquipSkill_231 天衣無崩
    if Ed.EquipSkill[142] then
        if not Pl.EquipSkill_231 and St.isActiveEquipSkill230 then
            Pl.EquipSkill_231 = true
        elseif Pl.EquipSkill_231 and not St.isActiveEquipSkill230 then
            Pl.EquipSkill_231 = false
            AddChatInfomation(1, 142, Pl.EquipSkill_231)
        end
    end
    -- 143 Pl_EquipSkill_232 狂竜症【翔】
    if Ed.EquipSkill[143] then
        if not Pl.EquipSkill_232[1] and St._EquipSkill231_WireNumTimer == Pl.EquipSkill_232[2][Ed.EquipSkill[143]:get_field("SkillLv")] then
            Pl.EquipSkill_232[1] = true
        elseif Pl.EquipSkill_232[1] and St._EquipSkill231_WpOffTimer == 0 then
            Pl.EquipSkill_232[1] = false
            AddChatInfomation(1, 143, Pl.EquipSkill_232[1])
        end
    end
    -- 146 Pl_EquipSkill_233 緩衝


    -- 1 Pl_KitchenSkill_000 おだんご研磨術
    -- 2 Pl_KitchenSkill_001 おだんご乗り上手
    -- 3 Pl_KitchenSkill_002 おだんご火事場力
    if Kd.KitchenSkill[3] then
        if not Pl.KitchenSkill_002[1] and St.playerHealth <= Pl.KitchenSkill_002[2][Kd.KitchenSkill[3]:get_field("_SkillLv")] then
            Pl.KitchenSkill_002[1] = true
            AddChatInfomation(2, 3, Pl.KitchenSkill_002[1])
        elseif Pl.KitchenSkill_002[1] and St.playerHealth > Pl.KitchenSkill_002[2][Kd.KitchenSkill[3]:get_field("_SkillLv")] then
            Pl.KitchenSkill_002[1] = false
            AddChatInfomation(2, 3, Pl.KitchenSkill_002[1])
        end
    end
    -- 4 Pl_KitchenSkill_003 おだんご解体術【小】
    -- 5 Pl_KitchenSkill_004 おだんご解体術【大】
    -- 6 Pl_KitchenSkill_005 おだんご医療術【小】
    -- 7 Pl_KitchenSkill_006 おだんご医療術【大】
    -- 8 Pl_KitchenSkill_007 おだんご体術
    -- 9 Pl_KitchenSkill_008 おだんご火薬術
    -- 10 Pl_KitchenSkill_009 おだんご特殊攻撃術
    -- 11 Pl_KitchenSkill_010 おだんご防御術【小】
    -- 12 Pl_KitchenSkill_011 おだんご防御術【大】
    -- 13 Pl_KitchenSkill_012 おだんご収穫祭
    -- 14 Pl_KitchenSkill_013 おだんご射撃術
    -- 15 Pl_KitchenSkill_014 おだんご幸運術
    -- 16 Pl_KitchenSkill_015 おだんご激運術
    -- 17 Pl_KitchenSkill_016 おだんごはじかれ上手
    -- 18 Pl_KitchenSkill_017 おだんご弱いの来い！
    -- 19 Pl_KitchenSkill_018 おだんご換算術
    -- 20 Pl_KitchenSkill_019 おだんご暴れ撃ち
    -- 21 Pl_KitchenSkill_020 おだんご壁走り達人
    -- 22 Pl_KitchenSkill_021 おだんごＫＯ術
    -- 23 Pl_KitchenSkill_022 おだんご金運術
    -- 24 Pl_KitchenSkill_023 おだんご砲撃術
    -- 25 Pl_KitchenSkill_024 おだんごド根性
    if Kd.KitchenSkill[25] and not Pl.KitchenSkill_024 and St.isHaveKitchenGuts then
        Pl.KitchenSkill_024 = true
    elseif not Kd.KitchenSkill[25] and Pl.KitchenSkill_024 and not St.isHaveKitchenGuts then
        AddChatInfomation(2, 25, Pl.KitchenSkill_024)
        Pl.KitchenSkill_024 = false
    end
    -- 26 Pl_KitchenSkill_025 おだんご免疫術
    -- 27 Pl_KitchenSkill_026 おだんごオトモ指導術
    -- 28 Pl_KitchenSkill_027 おだんご短期催眠術
    if Kd.KitchenSkill[28] then
        if not Pl.KitchenSkill_027[1] and St._KitchenSkill027Timer == Pl.KitchenSkill_027[2][Kd.KitchenSkill[28]:get_field("_SkillLv")] * 3600 then
            Pl.KitchenSkill_027[1] = true
        elseif Pl.KitchenSkill_027[1] and St._KitchenSkill027Timer == 0 then
            Pl.KitchenSkill_027[1] = false
            AddChatInfomation(2, 28, Pl.KitchenSkill_027[1])
        end
    end
    -- 29 Pl_KitchenSkill_028 おだんごふんばり術
    -- 30 Pl_KitchenSkill_029 おだんごビルドアップ
    -- 31 Pl_KitchenSkill_030 おだんご報酬金保険
    -- 32 Pl_KitchenSkill_031 おだんご復活術
    -- 33 Pl_KitchenSkill_032 おだんご環境生物召喚
    -- 34 Pl_KitchenSkill_033 おだんご投擲術
    -- 35 Pl_KitchenSkill_034 おだんご火耐性【小】
    -- 36 Pl_KitchenSkill_035 おだんご火耐性【大】
    -- 37 Pl_KitchenSkill_036 おだんご水耐性【小】
    -- 38 Pl_KitchenSkill_037 おだんご水耐性【大】
    -- 39 Pl_KitchenSkill_038 おだんご雷耐性【小】
    -- 40 Pl_KitchenSkill_039 おだんご雷耐性【大】
    -- 41 Pl_KitchenSkill_040 おだんご氷耐性【小】
    -- 42 Pl_KitchenSkill_041 おだんご氷耐性【大】
    -- 43 Pl_KitchenSkill_042 おだんご龍耐性【小】
    -- 44 Pl_KitchenSkill_043 おだんご龍耐性【大】
    -- 45 Pl_KitchenSkill_044 おだんご採蜜術
    -- 46 Pl_KitchenSkill_045 おだんご腹へらず
    -- 47 Pl_KitchenSkill_046 おだんご鳥寄せの術
    -- 48 Pl_KitchenSkill_047 おだんごぶら下がり術
    -- 49 Pl_KitchenSkill_048 おだんご防護術
    if Kd.KitchenSkill[49] then
        if not Pl.KitchenSkill_048[1] and St._KitchenSkill048_Damage >= Pl.KitchenSkill_048[2][Kd.KitchenSkill[49]:get_field("_SkillLv")] then
            Pl.KitchenSkill_048[1] = true
        end
    end
    -- 50 Pl_KitchenSkill_049 おだんご強化延長術
    -- 51 Pl_KitchenSkill_050 おだんご生命力
    -- 52 Pl_KitchenSkill_051 おだんご逃走術
    -- 53 Pl_KitchenSkill_052 おだんご具足術
    -- 54 Pl_KitchenSkill_053 おだんご疾替え術
    -- 55 Pl_KitchenSkill_054 おだんご絆術
    -- 56 Pl_KitchenSkill_055 おだんご超回復力


    -- 0 Concert_000 自分強化
    -- 1 Concert_001 攻撃力UP
    -- 2 Concert_002 防御力UP
    -- 3 Concert_003 会心率UP
    -- 4 Concert_004 属性攻撃力UP
    -- 5 Concert_005 攻撃力＆防御力UP
    -- 6 Concert_006 攻撃力＆会心率UP
    -- 7 Concert_007 のけぞり無効
    -- 8 Concert_008 聴覚保護【小】
    -- 9 Concert_009 聴覚保護【大】
    -- 10 Concert_010 振動無効
    -- 11 Concert_011 風圧無効
    -- 12 Concert_012 気絶無効
    -- 13 Concert_013 全属性やられ無効
    -- 14 Concert_014 精霊王の加護
    -- 15 Concert_015 体力回復【小】
    -- 16 Concert_016 体力回復【大】
    -- 17 Concert_017 解毒＆体力回復【小】
    -- 18 Concert_018 体力継続回復
    -- 19 Concert_019 スタミナ消費軽減
    -- 20 Concert_020 スタミナ回復速度UP
    -- 21 Concert_021 斬れ味消費軽減
    -- 22 Concert_022 地形ダメージ無効
    -- 23 Concert_023 高周衝撃波
    -- 24 Concert_024 音の防壁
    -- 25 Concert_025 気炎の旋律
end

sdk.hook(sdk.find_type_definition("snow.player.PlayerManager"):get_method("update"), update)


local preDamage = 0
local postDamage = 0

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("damageVital(System.Single, System.Boolean, System.Boolean, System.Boolean, System.Boolean, System.Boolean)"),
    function(args)
        postDamage = sdk.to_float(args[3])
    end)

local function on_pre_checkDamage_calcDamage(args)
    preDamage = sdk.to_float(args[3]) * -1
    if preDamage == 0.0 then
        postDamage = 0.0
    end
end

local function on_post_checkDamage_calcDamage(retval)
    if St.get_IsEnableEquipSkill225 or postDamage == preDamage or preDamage == 0 then
        -- postDamage = 0
        return retval
    end

    if Pl.KitchenSkill_048[1] then
        preDamage = preDamage * Pl.KitchenSkill_048[3][Kd.KitchenSkill[49]:get_field("_SkillLv")]
        Pl.KitchenSkill_048[1] = false
    end

    if Pl.EquipSkill_222[1] then
        preDamage = preDamage * Pl.EquipSkill_222[2][Ed.EquipSkill[135]:get_field("SkillLv")]
        Pl.EquipSkill_222[1] = false
    end

    if preDamage ~= postDamage then
        getChatManager():call("reqAddChatInfomation", getMessageByName("ChatLog_Co_Skill_01"), GUI_COMMON_MEAL_SKILL_NOTICE)
    end

    return retval
end

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("checkDamage_calcDamage(System.Single, System.Single, snow.player.PlayerDamageInfo, System.Boolean)"), on_pre_checkDamage_calcDamage, on_post_checkDamage_calcDamage)
