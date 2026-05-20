-- Initialisation de la base de données 1.12.1
-- Initialisation sécurisée de la base de données 1.12.1 via les événements de WoW
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("VARIABLES_LOADED")
eventFrame:SetScript("OnEvent", function()
    if not FCM_Database then
        FCM_Database = { parieurs = {}, totalA = 0, totalB = 0, gainsCalcules = {}, gainsPayes = {}, nomA = "Combattant A", nomB = "Combattant B", classA = nil, classB = nil, levelA = nil, levelB = nil, etape = 1, lang = "fr" }
    end
    if not FCM_Database.tresorerie then
        FCM_Database.tresorerie = 0
    end
    if not FCM_Database.historique then
        FCM_Database.historique = {}
    end
    if not FCM_Database.hallOfFame then
        FCM_Database.hallOfFame = {}
    end
    if FCM_Database.isMakgora == nil then
        FCM_Database.isMakgora = false
    end
    if not FCM_Database.lang then
        FCM_Database.lang = "fr"
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00" .. (FCM_L and FCM_L("MSG_LOADED") or "Fight Club Manager loaded!"))
end)

----------------------------------------------------
-- TRADUCTIONS (LOCALIZATION)
----------------------------------------------------
local FCM_Locales = {
    fr = {
        BTN_TARGET_A = "Cibler A",
        BTN_TARGET_B = "Cibler B",
        BTN_WINNER = "Vainqueur !",
        LBL_BET = "Mise :",
        BTN_TRADE = "Échanger",
        BTN_MAKGORA = "Mak'gora",
        BTN_RESET = "RAZ",
        BTN_POSTAL = "Préparer Mandat",
        BTN_PAY_HISTO = "Payer gain en attente",
        BTN_RESET_PAID_HISTO = "Effacer Payés",
        BTN_RESET_ALL_HISTO = "Effacer TOUT",
        BTN_RESET_HOF = "Effacer le Hall of Fame",
        BTN_RESET_TREASURY = "Remettre à zéro",
        TITLE_HOF = "|cffffd100✖ HALL OF FAME ✖|r",
        TITLE_HIST = "|cff2095f3✖ HISTORIQUE DES MATCHS ✖|r",
        TITLE_RULES = "|cff2095f3✖ RÈGLES DU CLUB ✖|r",
        TITLE_TREASURY = "|cffffd100✖ TRÉSORERIE GUILDE ✖|r",
        TITLE_MAIN = "|cffaa0000✖ THE RAVENHOLDT FIGHT CLUB ✖|r",
        STEP1 = "Étape 1 : |cff2095f3Choix des Gladiateurs|r",
        STEP2 = "Étape 2 : |cff00ff00Récolte des Paris|r",
        STEP3 = "Étape 3 : |cffffd100Combat en cours...|r",
        STEP4 = "Étape 4 : |cffff2222Envoi Postal des Gains|r",
        TXT_BETS = "Mises : ",
        TXT_ODDS = "Cote : ",
        TXT_BET_ON = "Miser ",
        BTN_MATCH_DONE = "Match terminé",
        CHAT_MSG_PREFIX = "[Fight Club] ",
        CHAT_ERROR_PREFIX = "|cffff0000[Fight Club] Erreur : |r",
        CHAT_SUCCESS_PREFIX = "|cff00ff00[Fight Club] |r",
        CHAT_INFO_PREFIX = "|cff2095f3[Fight Club] |r",
        MSG_LOADED = "Fight Club Manager chargé ! /fc pour l'afficher.",
        MSG_SESSION_RESET = "--- Session réinitialisée à zéro ! ---",
        ERROR_TARGET_PLAYER_MONEY = "Vous devez cibler le joueur qui donne l'argent !",
        ERROR_BET_ZERO = "Le montant entré est nul.",
        INFO_VICTORY_HOF = "Victoire de %s enregistrée au Hall of Fame !",
        INFO_NO_WINNING_BETS = "Aucun survivant n'avait de mise sur lui. La maison garde tout (sauf gain du combattant).",
        INFO_VICTORY_TAX = "Victoire de %s ! Taxe Guilde (%s) : %s | Gain Combattant (%s) : %s",
        ERROR_MAILBOX_CLOSED = "Vous devez ouvrir une boîte aux lettres en jeu d'abord !",
        ERROR_NOT_ENOUGH_MONEY = "Fonds insuffisants pour envoyer %s (+ 30c frais).",
        MAIL_SUBJECT = "Fight Club - Vos gains !",
        INFO_MAIL_READY = "Courrier préparé pour %s (%s). Cliquez sur Envoyer !",
        SUCCESS_TREASURY_RESET = "La trésorerie a été remise à zéro.",
        SUCCESS_ALL_PAID = "Tous les gains de l'historique ont été payés !",
        SUCCESS_HISTORY_CLEARED_PAID = "Historique nettoyé (%d match(s) effacé(s)). Les matchs avec des gains non payés ont été conservés.",
        SUCCESS_HISTORY_CLEARED_ALL = "L'historique complet des matchs a été effacé.",
        CONFIRM_DELETE_ALL_HISTORY_TEXT = "Êtes-vous sûr de vouloir effacer TOUT l'historique des matchs ?\n\n|cffff0000Cette action est irréversible et supprimera également les matchs avec des gains non payés.|r",
        SUCCESS_HOF_CLEARED = "Le Hall of Fame a été effacé.",
        CONFIRM_DELETE_HOF_TEXT = "Êtes-vous sûr de vouloir effacer TOUT le Hall of Fame ?\n\n|cffff0000Cette action est irréversible.|r",
        CONFIRM_RESET_TREASURY_TEXT = "Êtes-vous sûr de vouloir remettre la trésorerie à zéro ?\n\n|cffff0000Cette action est irréversible.|r",
        ERROR_REGISTER_FIGHTERS = "Enregistrez deux combattants !",
        ERROR_ALREADY_FIGHTER_B = "Ce joueur est déjà défini comme Combattant B !",
        ERROR_TARGET_FIGHTER_A = "Ciblez le combattant A !",
        ERROR_ALREADY_FIGHTER_A = "Ce joueur est déjà défini comme Combattant A !",
        ERROR_TARGET_FIGHTER_B = "Ciblez le combattant B !",
        ERROR_TARGET_FOR_TRADE = "Ciblez un joueur pour lancer un échange !",
        SUCCESS_ALL_MAIL_PREPARED = "Tous les courriers des gagnants ont été préparés !",
        TITLE_TREASURY_TAXES = "Taxes Totales Engrangées",
        TITLE_RULES_HEADER = "Les Règles du Fight Club",
        RULES_TEXT = "|cff2095f3RÈGLE 1 :|r Il est interdit de parler du Fight Club.\n\nTu ne lances pas de message sur le canal /1. Tu ne spams pas le /2 d'Ironforge ou d'Orgrimmar. Si un MJ ou les flics te demandent ce qu'on fabrique à cinquante dans les montagnes d'Alterac, tu réponds que tu cueilles de l'Hivernale. Ce qui se passe à Ravenholdt reste à Ravenholdt.\n\n|cff2095f3RÈGLE 2 :|r Il est INTERDIT de parler du Fight Club.\n\nSi ton compagnon de quête te demande où sont passées les 50 pièces d'or de la banque de guilde, tu lances une bombe fumigène et tu fuis. Le premier qui balance un screenshot ou fait foirer la couverture servira de cible d'entraînement pour les assassins du manoir.\n\n|cff2095f3RÈGLE 3 :|r Si quelqu'un dit stop, s'agenouille ou passe l'arme à gauche, le combat s'arrête.\n\nLe nettoyage s'arrête quand le travail est fait. En duel classique, le combat prend fin à la seconde où l'un de vous tombe à 1 PV et que le perdant pose le genou au sol en signe de soumission. En mode Mak'gora, ça se termine quand l’un de vous deux libère son esprit et devient un fantôme. Notre registre valide le survivant, on ramasse les morceaux, et on passe au suivant. Pas de pitié, pas de réclamation.\n\n|cff2095f3RÈGLE 4 :|r Seulement deux personnes par combat.\n\nLe business se règle en tête-à-tête, pas en émeute. Vos familiers de classe sont tolérés si vous êtes Chasseur ou Démoniste, c'est votre gagne-pain. Pour le reste, c'est du 1v1 pur. Si on chope un pote à vous caché dans un buisson pour vous filer un coup de main ou vous soigner en douce, on vous égorge tous les deux et on jette vos corps dans les douves du manoir.\n\n|cff2095f3RÈGLE 5 :|r Un combat à la fois.\n\nOn fait les choses proprement. L'arène doit être dégagée pour que les parieurs puissent voir où part leur argent et analyser les cotes sur le registre sans loucher. On ne pollue pas la table de jeu du Syndicat. Un seul duel est géré à la fois.\n\n|cff2095f3RÈGLE 6 :|r Pas de buffs de classe extérieurs.\n\nÀ l'ancienne, on disait \\\"pas de chemise, pas de chaussures\\\". Ici, la loi est plus stricte. Tu viens avec tes propres techniques, tes potions, ton équipement et tes tripes. Si on détecte une Endurance de Prêtre ou une Bénédiction de Paladin qui n'est pas la tienne avant que le registre ne verrouille les paris, tu passes pour un lâche, et le Syndicat n'aime pas les lâches.\n\n|cff2095f3RÈGLE 7 :|r Pas de racisme, pas de sexisme, pas d'incitation à la haine (Et pas de pleureuses).\n\nOn est des truands, des hors-la-loi, mais on a des principes. Tu as le droit de provoquer et de faire du trash-talk pour chauffer la salle, mais si tu franchis la ligne, tu te fais exclure de la famille définitivement. Idem pour les rageux qui ououinent parce qu'ils ont perdu leur thune : ici, on encaisse ses gains avec le sourire et on accepte ses pertes comme un homme. Le premier qui tape un scandale servira de paillasson aux voleurs du manoir et ses PO resteront dans nos caisses.\n\n|cff2095f3RÈGLE 8 :|r Si c'est votre premier soir au Fight Club, vous devez parier et/ou vous battre.\n\nSi tu as trouvé le chemin secret, tu participes à l'économie ou au spectacle, personne ne reste les bras croisés. Soit tu sors l'or de tes poches pour miser sur un de nos poulains, soit tu trouves un type de ton calibre (écart maximum de +1 ou -1 niveau) et tu descends dans l'arène prouver ce que tu vaux. Tout le monde doit croquer ou saigner.\n\n\n|cffffd100« Suivez ces règles à la lettre. À Ravenholdt, le sang coule, l'or change de mains, mais la discipline reste absolue. Si vous brisez ce code, vous n'aurez pas à vous soucier des forces de l'ordre... mes assassins s'occuperont de vous avant l'aube. »\n\n— Fahrad, Maître de la Ligue de Ravenholdt|r",
        HOF_CLASSIC_HEADER = "|cff00ff00Combats Classiques|r",
        HOF_MAKGORA_HEADER = "|cffff0000Combats Mak'gora|r",
        HOF_NO_CHAMPION = "Aucun champion enregistré.",
        HOF_NO_CHAMPION_TYPE = "Aucun champion.",
        HOF_VICTORIES = "%d Victoire(s)",
        HISTORY_NO_MATCH = "Aucun match enregistré.",
        HISTORY_MATCH_DATE = "|cffffd100--- Match du %s ---|r",
        HISTORY_MATCH_INFO = "%s VS %s |cffaaaaaa(Vainqueur: %s)|r",
        STATUS_PAID = "|cff00ff00[Payé]|r",
        STATUS_UNPAID = "|cffff0000[Non payé]|r",
        FIGHTER_TAG = "|cffff8000%s (Combattant)|r",
        HISTORY_NO_GAINS = "  • |cffaaaaaaAucun gain redistribué.|r",
        LEVEL_TAG = "\n|cffaaaaaa(Niv. %s)|r",
        WINNERS_LIST_TITLE = "|cff00ff00--- LISTE DES GAGNANTS ---|r\n(Ouvrez la boîte aux lettres et cliquez sur le bouton vert)",
        BETS_REGISTER_TITLE = "|cffbffff0--- REGISTRE DES MISES ---|r",
    },
    en = {
        BTN_TARGET_A = "Target A",
        BTN_TARGET_B = "Target B",
        BTN_WINNER = "Winner!",
        LBL_BET = "Bet:",
        BTN_TRADE = "Trade",
        BTN_MAKGORA = "Mak'gora",
        BTN_RESET = "Reset",
        BTN_POSTAL = "Prepare Mail",
        BTN_PAY_HISTO = "Pay pending gain",
        BTN_RESET_PAID_HISTO = "Clear Paid",
        BTN_RESET_ALL_HISTO = "Clear ALL",
        BTN_RESET_HOF = "Clear Hall of Fame",
        BTN_RESET_TREASURY = "Reset Treasury",
        TITLE_HOF = "|cffffd100✖ HALL OF FAME ✖|r",
        TITLE_HIST = "|cff2095f3✖ MATCH HISTORY ✖|r",
        TITLE_RULES = "|cff2095f3✖ CLUB RULES ✖|r",
        TITLE_TREASURY = "|cffffd100✖ GUILD TREASURY ✖|r",
        TITLE_MAIN = "|cffaa0000✖ THE RAVENHOLDT FIGHT CLUB ✖|r",
        STEP1 = "Step 1: |cff2095f3Choose Gladiators|r",
        STEP2 = "Step 2: |cff00ff00Collect Bets|r",
        STEP3 = "Step 3: |cffffd100Combat in progress...|r",
        STEP4 = "Step 4: |cffff2222Send Mail Winnings|r",
        TXT_BETS = "Bets: ",
        TXT_ODDS = "Odds: ",
        TXT_BET_ON = "Bet ",
        BTN_MATCH_DONE = "Match Finished",
        CHAT_MSG_PREFIX = "[Fight Club] ",
        CHAT_ERROR_PREFIX = "|cffff0000[Fight Club] Error: |r",
        CHAT_SUCCESS_PREFIX = "|cff00ff00[Fight Club] |r",
        CHAT_INFO_PREFIX = "|cff2095f3[Fight Club] |r",
        MSG_LOADED = "Fight Club Manager loaded! /fc to show.",
        MSG_SESSION_RESET = "--- Session reset to zero! ---",
        ERROR_TARGET_PLAYER_MONEY = "You must target the player who is giving the money!",
        ERROR_BET_ZERO = "The entered amount is zero.",
        INFO_VICTORY_HOF = "Victory of %s recorded in the Hall of Fame!",
        INFO_NO_WINNING_BETS = "No survivor had a bet on them. The house keeps everything (except the fighter's prize).",
        INFO_VICTORY_TAX = "Victory for %s! Guild Tax (%s): %s | Fighter's Prize (%s): %s",
        ERROR_MAILBOX_CLOSED = "You must open a mailbox in-game first!",
        ERROR_NOT_ENOUGH_MONEY = "Insufficient funds to send %s (+ 30c fee).",
        MAIL_SUBJECT = "Fight Club - Your winnings!",
        INFO_MAIL_READY = "Mail prepared for %s (%s). Click Send!",
        SUCCESS_TREASURY_RESET = "The treasury has been reset to zero.",
        SUCCESS_ALL_PAID = "All winnings from the history have been paid!",
        SUCCESS_HISTORY_CLEARED_PAID = "History cleaned up (%d match(es) cleared). Matches with unpaid winnings have been kept.",
        SUCCESS_HISTORY_CLEARED_ALL = "The entire match history has been cleared.",
        CONFIRM_DELETE_ALL_HISTORY_TEXT = "Are you sure you want to clear the ENTIRE match history?\n\n|cffff0000This action is irreversible and will also delete matches with unpaid winnings.|r",
        SUCCESS_HOF_CLEARED = "The Hall of Fame has been cleared.",
        CONFIRM_DELETE_HOF_TEXT = "Are you sure you want to clear the ENTIRE Hall of Fame?\n\n|cffff0000This action is irreversible.|r",
        CONFIRM_RESET_TREASURY_TEXT = "Are you sure you want to reset the treasury to zero?\n\n|cffff0000This action is irreversible.|r",
        ERROR_REGISTER_FIGHTERS = "Register two fighters!",
        ERROR_ALREADY_FIGHTER_B = "This player is already set as Fighter B!",
        ERROR_TARGET_FIGHTER_A = "Target fighter A!",
        ERROR_ALREADY_FIGHTER_A = "This player is already set as Fighter A!",
        ERROR_TARGET_FIGHTER_B = "Target fighter B!",
        ERROR_TARGET_FOR_TRADE = "Target a player to initiate a trade!",
        SUCCESS_ALL_MAIL_PREPARED = "All winner mails have been prepared!",
        TITLE_TREASURY_TAXES = "Total Taxes Collected",
        TITLE_RULES_HEADER = "The Rules of the Fight Club",
        RULES_TEXT = "|cff2095f3RULE 1:|r You do not talk about Fight Club.\n\nYou don't post messages in the /1 channel. You don't spam the /2 chat in Ironforge or Orgrimmar. If a GM or the guards ask what fifty of us are doing in the Alterac Mountains, you answer that you're picking Wintersbite. What happens in Ravenholdt stays in Ravenholdt.\n\n|cff2095f3RULE 2:|r You DO NOT talk about Fight Club.\n\nIf your questing partner asks where the 50 gold pieces from the guild bank went, you throw a smoke bomb and run. The first one to post a screenshot or blow our cover will serve as target practice for the manor's assassins.\n\n|cff2095f3RULE 3:|r If someone says stop, kneels, or kicks the bucket, the fight is over.\n\nThe cleanup ends when the job is done. In a classic duel, the fight ends the second one of you drops to 1 HP and the loser takes a knee in submission. In Mak'gora mode, it ends when one of you releases their spirit and becomes a ghost. Our registry validates the survivor, we pick up the pieces, and move on to the next one. No mercy, no complaints.\n\n|cff2095f3RULE 4:|r Only two people per fight.\n\nBusiness is settled one-on-one, not in a riot. Your class pets are tolerated if you're a Hunter or Warlock; it's your livelihood. For everyone else, it's pure 1v1. If we catch a buddy of yours hiding in a bush to give you a hand or a sneaky heal, we'll slit both your throats and throw your bodies in the manor's moat.\n\n|cff2095f3RULE 5:|r One fight at a time.\n\nWe do things cleanly. The arena must be clear so bettors can see where their money is going and analyze the odds on the ledger without going cross-eyed. We don't pollute the Syndicate's gambling table. Only one duel is managed at a time.\n\n|cff2095f3RULE 6:|r No outside class buffs.\n\nIn the old days, they said \\\"no shirt, no shoes.\\\" Here, the law is stricter. You come with your own skills, your potions, your gear, and your guts. If we detect a Priest's Fortitude or a Paladin's Blessing that isn't yours before the registry locks the bets, you'll be seen as a coward, and the Syndicate doesn't like cowards.\n\n|cff2095f3RULE 7:|r No racism, no sexism, no hate speech (And no whiners).\n\nWe're thugs, outlaws, but we have principles. You're allowed to provoke and use trash-talk to hype up the crowd, but if you cross the line, you're out of the family for good. Same goes for the ragers who whine because they lost their money: here, we collect our winnings with a smile and accept our losses like a man. The first one to throw a fit will serve as a doormat for the manor's rogues, and their gold will stay in our coffers.\n\n|cff2095f3RULE 8:|r If this is your first night at Fight Club, you have to bet and/or fight.\n\nIf you found the secret path, you participate in the economy or the show; no one stands around idle. Either you pull gold from your pockets to bet on one of our contenders, or you find someone of your caliber (maximum level difference of +1 or -1) and get down in the arena to prove your worth. Everyone must either cash in or bleed.\n\n\n|cffffd100\"Follow these rules to the letter. In Ravenholdt, blood is shed, gold changes hands, but discipline remains absolute. If you break this code, you won't have to worry about law enforcement... my assassins will take care of you before dawn.\"\n\n— Fahrad, Master of the Ravenholdt League|r",
        HOF_CLASSIC_HEADER = "|cff00ff00Classic Fights|r",
        HOF_MAKGORA_HEADER = "|cffff0000Mak'gora Fights|r",
        HOF_NO_CHAMPION = "No champion recorded.",
        HOF_NO_CHAMPION_TYPE = "No champion.",
        HOF_VICTORIES = "%d Victory(s)",
        HISTORY_NO_MATCH = "No match recorded.",
        HISTORY_MATCH_DATE = "|cffffd100--- Match from %s ---|r",
        HISTORY_MATCH_INFO = "%s VS %s |cffaaaaaa(Winner: %s)|r",
        STATUS_PAID = "|cff00ff00[Paid]|r",
        STATUS_UNPAID = "|cffff0000[Unpaid]|r",
        FIGHTER_TAG = "|cffff8000%s (Fighter)|r",
        HISTORY_NO_GAINS = "  • |cffaaaaaaNo winnings redistributed.|r",
        LEVEL_TAG = "\n|cffaaaaaa(Lvl. %s)|r",
        WINNERS_LIST_TITLE = "|cff00ff00--- WINNERS LIST ---|r\n(Open the mailbox and click the green button)",
        BETS_REGISTER_TITLE = "|cffbffff0--- BETS REGISTER ---|r",
    }
}

local function FCM_L(key)
    local lang = (FCM_Database and FCM_Database.lang) or "fr"
    return FCM_Locales[lang][key] or key
end

----------------------------------------------------
-- FENETRES DE CONFIRMATION (POPUP)
----------------------------------------------------
StaticPopupDialogs["FCM_CONFIRM_DELETE_ALL_HISTORY"] = {
    text = "%s", -- Le texte est passé dynamiquement via StaticPopup_Show
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function()
        FCM_Database.historique = {}
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_SUCCESS_PREFIX") .. FCM_L("SUCCESS_HISTORY_CLEARED_ALL"))
        if FCM_MainFrame then FCM_MainFrame.RefreshUI() end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
};

StaticPopupDialogs["FCM_CONFIRM_RESET_TREASURY"] = {
    text = "%s",
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function()
        FCM_Database.tresorerie = 0
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_SUCCESS_PREFIX") .. FCM_L("SUCCESS_TREASURY_RESET"))
        if FCM_MainFrame then FCM_MainFrame.RefreshUI() end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
};

StaticPopupDialogs["FCM_CONFIRM_DELETE_HOF"] = {
    text = "%s",
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function()
        FCM_Database.hallOfFame = {}
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_SUCCESS_PREFIX") .. FCM_L("SUCCESS_HOF_CLEARED"))
        if FCM_MainFrame then FCM_MainFrame.RefreshUI() end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
};

----------------------------------------------------
-- FONCTIONS OUTILS & CONVERTISSEURS (VANILLA)
----------------------------------------------------
local CLASS_ICON_TCOORDS = {
    ["WARRIOR"] = {0, 0.25, 0, 0.25},
    ["MAGE"]    = {0.25, 0.5, 0, 0.25},
    ["ROGUE"]   = {0.5, 0.75, 0, 0.25},
    ["DRUID"]   = {0.75, 1.0, 0, 0.25},
    ["HUNTER"]  = {0, 0.25, 0.25, 0.5},
    ["SHAMAN"]  = {0.25, 0.5, 0.25, 0.5},
    ["PRIEST"]  = {0.5, 0.75, 0.25, 0.5},
    ["WARLOCK"] = {0.75, 1.0, 0.25, 0.5},
    ["PALADIN"] = {0, 0.25, 0.5, 0.75}
}

local function FormaterArgent(cuivre)
    local g = math.floor(cuivre / 10000)
    local s = math.floor(math.mod(cuivre, 10000) / 100)
    local c = math.mod(cuivre, 100)
    
    local str = ""
    if g > 0 then 
        str = "|cffffd100" .. g .. "g|r" 
    end
    if s > 0 then 
        str = str .. (str ~= "" and " " or "") .. "|cffe6e6e6" .. s .. "s|r" 
    end
    if c > 0 or str == "" then 
        str = str .. (str ~= "" and " " or "") .. "|cffc79c6e" .. c .. "c|r" 
    end
    return str
end

local function ObtenirCouleurCote(cote)
    if cote <= 1.10 then return "00ff00"
    elseif cote <= 1.50 then return "80ff00"
    elseif cote <= 2.00 then return "ffff00"
    elseif cote <= 3.00 then return "ff8000"
    else return "ff2222" end
end

local function AjusterValeurCase(box, delta)
    local val = tonumber(box:GetText()) or 0
    val = val + delta
    if val < 0 then val = 0 end
    box:SetText(tostring(val))
end

----------------------------------------------------
-- LOGIQUE MÉTIER DES ÉTAPES
----------------------------------------------------
local function ResetClub()
    local ancienneTresorerie = FCM_Database.tresorerie or 0
    local ancienHistorique = FCM_Database.historique or {}
    local ancienHallOfFame = FCM_Database.hallOfFame or {}
    FCM_Database = { parieurs = {}, totalA = 0, totalB = 0, gainsCalcules = {}, gainsPayes = {}, nomA = FCM_L("BTN_TARGET_A"), nomB = FCM_L("BTN_TARGET_B"), classA = nil, classB = nil, levelA = nil, levelB = nil, etape = 1, tresorerie = ancienneTresorerie, historique = ancienHistorique, hallOfFame = ancienHallOfFame, isMakgora = false, lang = FCM_Database.lang or "fr" }
    DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_MSG_PREFIX") .. FCM_L("MSG_SESSION_RESET"))
    if FCM_MainFrameModelA then FCM_MainFrameModelA:ClearModel() end
    if FCM_MainFrameModelB then FCM_MainFrameModelB:ClearModel() end
    if FCM_MainFrame then FCM_MainFrame.RefreshUI() end
end

local function EnregistrerPari(combattant, g, s, c)
    local pseudo = GetUnitName("target")
    if not pseudo or not UnitIsPlayer("target") then
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_TARGET_PLAYER_MONEY"))
        return
    end

    local gold = tonumber(g) or 0
    local silver = tonumber(s) or 0
    local copper = tonumber(c) or 0
    local montantCuivre = (gold * 10000) + (silver * 100) + copper

    if montantCuivre <= 0 then 
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_BET_ZERO"))
        return 
    end

    -- Initialise le profil du parieur s'il n'existe pas encore
    if not FCM_Database.parieurs[pseudo] then
        FCM_Database.parieurs[pseudo] = { miseA = 0, miseB = 0 }
    end
    
    if combattant == "A" then
        FCM_Database.parieurs[pseudo].miseA = FCM_Database.parieurs[pseudo].miseA + montantCuivre
        FCM_Database.totalA = FCM_Database.totalA + montantCuivre
    else
        FCM_Database.parieurs[pseudo].miseB = FCM_Database.parieurs[pseudo].miseB + montantCuivre
        FCM_Database.totalB = FCM_Database.totalB + montantCuivre
    end
    if FCM_MainFrame then FCM_MainFrame.RefreshUI() end
end

local function CalculerGains(vainqueur)
    FCM_Database.gainsCalcules = {}
    FCM_Database.gainsPayes = {}
    
    local totalGlobal = FCM_Database.totalA + FCM_Database.totalB
    local isMakgora = FCM_Database.isMakgora
    
    local tauxTaxeTotal = isMakgora and 0.30 or 0.15
    local tauxGuilde = isMakgora and 0.02 or 0.10
    
    local taxeTotale = math.floor(totalGlobal * tauxTaxeTotal)
    local taxeGuilde = math.floor(totalGlobal * tauxGuilde)
    local gainCombattant = taxeTotale - taxeGuilde
    local cagnotteRedistribuer = totalGlobal - taxeTotale
    
    local totalMisesGagnantes = (vainqueur == "A") and FCM_Database.totalA or FCM_Database.totalB
    
    local nomGagnant = (vainqueur == "A" and FCM_Database.nomA or FCM_Database.nomB)
    if not FCM_Database.hallOfFame[nomGagnant] then FCM_Database.hallOfFame[nomGagnant] = { classic = 0, makgora = 0 } end
    if isMakgora then
        FCM_Database.hallOfFame[nomGagnant].makgora = FCM_Database.hallOfFame[nomGagnant].makgora + 1
    else
        FCM_Database.hallOfFame[nomGagnant].classic = FCM_Database.hallOfFame[nomGagnant].classic + 1
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_INFO_PREFIX") .. string.format(FCM_L("INFO_VICTORY_HOF"), nomGagnant))

    if totalMisesGagnantes == 0 then
        -- Si personne n'a parié sur le vainqueur, la maison garde tout (sauf la part du combattant) !
        FCM_Database.tresorerie = (FCM_Database.tresorerie or 0) + totalGlobal - gainCombattant
        
        if gainCombattant > 0 then
            FCM_Database.gainsCalcules[nomGagnant] = gainCombattant
        end
        
        table.insert(FCM_Database.historique, 1, {
            date = date("%d/%m/%y %H:%M"),
            nomA = FCM_Database.nomA,
            nomB = FCM_Database.nomB,
            vainqueur = nomGagnant .. (isMakgora and " |cffff0000[Mak'gora]|r" or " |cff00ff00[Classique]|r"),
            gainsCalcules = FCM_Database.gainsCalcules,
            gainsPayes = FCM_Database.gainsPayes
        })
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_MSG_PREFIX") .. FCM_L("INFO_NO_WINNING_BETS"))
        FCM_Database.etape = 4
        FCM_MainFrame.RefreshUI()
        return
    end
    
    -- S'il y a des gagnants, on ajoute uniquement la taxe
    FCM_Database.tresorerie = (FCM_Database.tresorerie or 0) + taxeGuilde

    local coef = cagnotteRedistribuer / totalMisesGagnantes
    
    for pseudo, data in pairs(FCM_Database.parieurs) do
        -- On récupère la mise gagnante (s'il avait misé sur les deux, on ne prend que celle du vainqueur)
        local miseGagnante = (vainqueur == "A") and data.miseA or data.miseB
        if miseGagnante > 0 then
            FCM_Database.gainsCalcules[pseudo] = math.floor(miseGagnante * coef)
        end
    end
    
    if gainCombattant > 0 then
        FCM_Database.gainsCalcules[nomGagnant] = (FCM_Database.gainsCalcules[nomGagnant] or 0) + gainCombattant
    end
    
    local pGuilde = isMakgora and "2%" or "10%"
    local pCombattant = isMakgora and "28%" or "5%"
    DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_MSG_PREFIX") .. string.format(FCM_L("INFO_VICTORY_TAX"), nomGagnant, pGuilde, FormaterArgent(taxeGuilde), pCombattant, FormaterArgent(gainCombattant)))

    table.insert(FCM_Database.historique, 1, {
        date = date("%d/%m/%y %H:%M"),
        nomA = FCM_Database.nomA,
        nomB = FCM_Database.nomB,
        vainqueur = nomGagnant .. (isMakgora and " |cffff0000[Mak'gora]|r" or " |cff00ff00[Classique]|r"),
        gainsCalcules = FCM_Database.gainsCalcules,
        gainsPayes = FCM_Database.gainsPayes
    })
    
    FCM_Database.etape = 4 
    FCM_MainFrame.RefreshUI()
end

-- Nouvelle fonction de paiement automatisé par courrier compatible 1.12.1
local function EnvoyerCourrierGagnant(nomGagnant, montantCuivre)
    if not MailFrame or not MailFrame:IsShown() then
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_MAILBOX_CLOSED"))
        return false
    end

    if GetMoney() < (montantCuivre + 30) then
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. string.format(FCM_L("ERROR_NOT_ENOUGH_MONEY"), FormaterArgent(montantCuivre)))
        return false
    end

    -- Bascule WoW nativement sur l'onglet "Envoyer un courrier" (Onglet 2)
    MailFrameTab2:Click()

    -- Remplissage des champs natifs de l'interface de Blizzard
    SendMailNameEditBox:SetText(nomGagnant)
    SendMailSubjectEditBox:SetText(FCM_L("MAIL_SUBJECT"))
    
    -- Séparation des cuivres pour les trois cases de courrier de Blizzard
    local g = math.floor(montantCuivre / 10000)
    local s = math.floor(math.mod(montantCuivre, 10000) / 100)
    local c = math.mod(montantCuivre, 100)
    
    SendMailMoneyGold:SetText(tostring(g))
    SendMailMoneySilver:SetText(tostring(s))
    SendMailMoneyCopper:SetText(tostring(c))

    -- Met à jour les calculs internes de Blizzard pour l'affichage des taxes d'envoi (30 PC)
    SendMailMoney_Update()

    DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_MSG_PREFIX") .. string.format(FCM_L("INFO_MAIL_READY"), nomGagnant, FormaterArgent(montantCuivre)))
    return true
end

----------------------------------------------------
-- INTERFACE GRAPHIQUE
----------------------------------------------------
local f = CreateFrame("Frame", "FCM_MainFrame", UIParent)
f:SetWidth(560) f:SetHeight(720) f:SetPoint("CENTER", UIParent, "CENTER")
f:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
f:SetBackdropColor(0.05, 0.05, 0.05, 0.95) -- Fond très sombre / gris anthracite
f:SetBackdropBorderColor(0.7, 0.1, 0.1, 1.0) -- Bordure rouge sang
f:EnableMouse(true) f:SetMovable(true) f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function() this:StartMoving() end)
f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
f:Hide()

local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)

local btnLang = CreateFrame("Button", "FCM_BtnLang", f, "UIPanelButtonTemplate")
btnLang:SetWidth(30) btnLang:SetHeight(20)
btnLang:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -10)
btnLang:SetScript("OnClick", function()
    FCM_Database.lang = (FCM_Database.lang == "fr") and "en" or "fr"
    f.RefreshUI()
end)

-- --- BANDEAU HEADER ---
f.HeaderBanner = f:CreateTexture(nil, "BACKGROUND")
f.HeaderBanner:SetTexture(0.12, 0.03, 0.03, 0.7) -- Fond bordeaux sombre
f.HeaderBanner:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -4)
f.HeaderBanner:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
f.HeaderBanner:SetHeight(56)

f.HeaderLine = f:CreateTexture(nil, "BORDER")
f.HeaderLine:SetTexture(0.6, 0.1, 0.1, 0.8) -- Ligne de séparation rouge
f.HeaderLine:SetPoint("TOPLEFT", f.HeaderBanner, "BOTTOMLEFT", 0, 0)
f.HeaderLine:SetPoint("TOPRIGHT", f.HeaderBanner, "BOTTOMRIGHT", 0, 0)
f.HeaderLine:SetHeight(2)

f.LeftDragon = f:CreateTexture(nil, "OVERLAY")
f.LeftDragon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
f.LeftDragon:SetWidth(72) f.LeftDragon:SetHeight(72)
f.LeftDragon:SetPoint("BOTTOMLEFT", f.HeaderBanner, "BOTTOMLEFT", 25, 0)

f.RightDragon = f:CreateTexture(nil, "OVERLAY")
f.RightDragon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
f.RightDragon:SetWidth(72) f.RightDragon:SetHeight(72)
f.RightDragon:SetPoint("BOTTOMRIGHT", f.HeaderBanner, "BOTTOMRIGHT", -25, 0)
f.RightDragon:SetTexCoord(1, 0, 0, 1) -- Inverse la texture pour la symétrie

f.MainTitle = f:CreateFontString(nil, "OVERLAY")
f.MainTitle:SetFont("Fonts\\MORPHEUS.ttf", 22, "OUTLINE")
f.MainTitle:SetPoint("TOP", f.HeaderBanner, "TOP", 0, -10)
f.MainTitle:SetText("|cffaa0000✖ THE RAVENHOLDT FIGHT CLUB ✖|r")

f.StepText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
f.StepText:SetPoint("TOP", f.HeaderBanner, "TOP", 0, -32)

-- --- COMBATTANT A ---
local modelA = CreateFrame("PlayerModel", "FCM_MainFrameModelA", f)
modelA:SetWidth(84); modelA:SetHeight(84) modelA:SetPoint("TOPLEFT", f, "TOPLEFT", 25, -65)

f.IconClassA = f:CreateTexture(nil, "OVERLAY")
f.IconClassA:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
f.IconClassA:SetWidth(18) f.IconClassA:SetHeight(18)
f.IconClassA:SetPoint("TOPLEFT", f, "TOPLEFT", 115, -65)
f.IconClassA:Hide()

f.NomAText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge") 
f.NomAText:SetPoint("TOPLEFT", f, "TOPLEFT", 140, -65)
f.NomAText:SetJustifyH("LEFT") f.NomAText:SetJustifyV("TOP")
f.NomAText:SetWidth(110)

f.TotalAText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
f.TotalAText:SetPoint("TOPLEFT", f, "TOPLEFT", 140, -110)
f.TotalAText:SetJustifyH("LEFT")
f.TotalAText:SetWidth(110)

f.CoteAText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
f.CoteAText:SetPoint("TOPLEFT", f, "TOPLEFT", 140, -130)
f.CoteAText:SetJustifyH("LEFT")
f.CoteAText:SetWidth(110)

local btnSetA = CreateFrame("Button", "FCM_BtnSetA", f, "UIPanelButtonTemplate")
btnSetA:SetWidth(110) btnSetA:SetHeight(24) btnSetA:SetPoint("TOPLEFT", f, "TOPLEFT", 25, -165)
btnSetA:SetText("Cibler A")

local btnWinA = CreateFrame("Button", "FCM_BtnWinA", f, "UIPanelButtonTemplate")
btnWinA:SetWidth(110) btnWinA:SetHeight(24) btnWinA:SetPoint("TOPLEFT", f, "TOPLEFT", 25, -165)
btnWinA:SetText("Vainqueur !")

-- --- VERSUS ---
f.VSButton = CreateFrame("Button", "FCM_BtnVS", f)
f.VSButton:SetWidth(48) f.VSButton:SetHeight(48)
f.VSButton:SetPoint("CENTER", f, "TOP", 0, -100)

f.VSIcon = f.VSButton:CreateTexture(nil, "OVERLAY")
f.VSIcon:SetTexture("Interface\\Icons\\Ability_Warrior_Challange")
f.VSIcon:SetTexCoord(0.14, 0.86, 0.14, 0.86) -- Zoom prononcé pour focaliser sur les épées et réduire l'effet carré
f.VSIcon:SetAllPoints(f.VSButton)

-- Effet de surbrillance au survol de l'icône pour montrer qu'elle est cliquable
local highlightVS = f.VSButton:CreateTexture(nil, "HIGHLIGHT")
highlightVS:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
highlightVS:SetBlendMode("ADD")
highlightVS:SetAllPoints(f.VSButton)

-- --- COMBATTANT B ---
local modelB = CreateFrame("PlayerModel", "FCM_MainFrameModelB", f)
modelB:SetWidth(84); modelB:SetHeight(84) modelB:SetPoint("TOPRIGHT", f, "TOPRIGHT", -25, -65)

f.IconClassB = f:CreateTexture(nil, "OVERLAY")
f.IconClassB:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
f.IconClassB:SetWidth(18) f.IconClassB:SetHeight(18)
f.IconClassB:SetPoint("TOPRIGHT", f, "TOPRIGHT", -115, -65)
f.IconClassB:Hide()

f.NomBText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
f.NomBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -140, -65)
f.NomBText:SetJustifyH("RIGHT") f.NomBText:SetJustifyV("TOP")
f.NomBText:SetWidth(110)

f.TotalBText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.TotalBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -140, -110)
f.TotalBText:SetJustifyH("RIGHT")
f.TotalBText:SetWidth(110)

f.CoteBText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.CoteBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -140, -130)
f.CoteBText:SetJustifyH("RIGHT")
f.CoteBText:SetWidth(110)

local btnSetB = CreateFrame("Button", "FCM_BtnSetB", f, "UIPanelButtonTemplate")
btnSetB:SetWidth(110) btnSetB:SetHeight(24) btnSetB:SetPoint("TOPRIGHT", f, "TOPRIGHT", -25, -165)
btnSetB:SetText("Cibler B")

local btnWinB = CreateFrame("Button", "FCM_BtnWinB", f, "UIPanelButtonTemplate")
btnWinB:SetWidth(110) btnWinB:SetHeight(24) btnWinB:SetPoint("TOPRIGHT", f, "TOPRIGHT", -25, -165)
btnWinB:SetText("Vainqueur !")

local line = f:CreateTexture(nil, "BACKGROUND")
line:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -210)
line:SetWidth(520) line:SetHeight(4) line:SetTexture(0.5, 0.05, 0.05, 0.8) -- Ligne plus épaisse et sombre

-- --- GRILLE ENTRÉE ARGENT ---
local lblMontant = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lblMontant:SetPoint("TOPLEFT", f, "TOPLEFT", 35, -235) lblMontant:SetText("Mise :")

local ebG = CreateFrame("EditBox", "FCM_InputGold", f, "InputBoxTemplate")
ebG:SetWidth(40) ebG:SetHeight(20) ebG:SetPoint("TOPLEFT", f, "TOPLEFT", 90, -233)
ebG:SetNumeric(true) ebG:SetMaxLetters(4) ebG:SetAutoFocus(false) ebG:SetText("1")
local lblG = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
lblG:SetPoint("LEFT", ebG, "RIGHT", 2, 0) lblG:SetText("|cffffd100G|r")
local texG = f:CreateTexture(nil, "OVERLAY")
texG:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")
texG:SetWidth(14); texG:SetHeight(14); texG:SetPoint("LEFT", lblG, "RIGHT", 2, -1)

local btnPlusG = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
btnPlusG:SetWidth(24) btnPlusG:SetHeight(14) btnPlusG:SetPoint("BOTTOM", ebG, "TOP", 0, 2)
btnPlusG:SetText("+") btnPlusG:SetScript("OnClick", function() AjusterValeurCase(ebG, 1) end)
local btnMinusG = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
btnMinusG:SetWidth(24) btnMinusG:SetHeight(14) btnMinusG:SetPoint("TOP", ebG, "BOTTOM", 0, -2)
btnMinusG:SetText("-") btnMinusG:SetScript("OnClick", function() AjusterValeurCase(ebG, -1) end)

local ebS = CreateFrame("EditBox", "FCM_InputSilver", f, "InputBoxTemplate")
ebS:SetWidth(30) ebS:SetHeight(20) ebS:SetPoint("LEFT", texG, "RIGHT", 35, 0)
ebS:SetNumeric(true) ebS:SetMaxLetters(2) ebS:SetAutoFocus(false) ebS:SetText("0")
local lblS = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
lblS:SetPoint("LEFT", ebS, "RIGHT", 2, 0) lblS:SetText("|cffe6e6e6S|r")
local texS = f:CreateTexture(nil, "OVERLAY")
texS:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")
texS:SetWidth(14); texS:SetHeight(14); texS:SetPoint("LEFT", lblS, "RIGHT", 2, -1)

local btnPlusS = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
btnPlusS:SetWidth(24) btnPlusS:SetHeight(14) btnPlusS:SetPoint("BOTTOM", ebS, "TOP", 0, 2)
btnPlusS:SetText("+") btnPlusS:SetScript("OnClick", function() AjusterValeurCase(ebS, 1) end)
local btnMinusS = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
btnMinusS:SetWidth(24) btnMinusS:SetHeight(14) btnMinusS:SetPoint("TOP", ebS, "BOTTOM", 0, -2)
btnMinusS:SetText("-") btnMinusS:SetScript("OnClick", function() AjusterValeurCase(ebS, -1) end)

local ebC = CreateFrame("EditBox", "FCM_InputCopper", f, "InputBoxTemplate")
ebC:SetWidth(30) ebC:SetHeight(20) ebC:SetPoint("LEFT", texS, "RIGHT", 35, 0)
ebC:SetNumeric(true) ebC:SetMaxLetters(2) ebC:SetAutoFocus(false) ebC:SetText("0")
local lblC = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
lblC:SetPoint("LEFT", ebC, "RIGHT", 2, 0) lblC:SetText("|cffc79c6eC|r")
local texC = f:CreateTexture(nil, "OVERLAY")
texC:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")
texC:SetWidth(14); texC:SetHeight(14); texC:SetPoint("LEFT", lblC, "RIGHT", 2, -1)

local btnPlusC = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
btnPlusC:SetWidth(24) btnPlusC:SetHeight(14) btnPlusC:SetPoint("BOTTOM", ebC, "TOP", 0, 2)
btnPlusC:SetText("+") btnPlusC:SetScript("OnClick", function() AjusterValeurCase(ebC, 1) end)
local btnMinusC = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
btnMinusC:SetWidth(24) btnMinusC:SetHeight(14) btnMinusC:SetPoint("TOP", ebC, "BOTTOM", 0, -2)
btnMinusC:SetText("-") btnMinusC:SetScript("OnClick", function() AjusterValeurCase(ebC, -1) end)

local btnTrade = CreateFrame("Button", "FCM_BtnTrade", f, "UIPanelButtonTemplate")
btnTrade:SetWidth(110) btnTrade:SetHeight(24) btnTrade:SetPoint("LEFT", texC, "RIGHT", 35, 0)
btnTrade:SetText("Échanger")

local btnMakgora = CreateFrame("Button", "FCM_BtnMakgora", f)
btnMakgora:SetWidth(32) btnMakgora:SetHeight(32)
btnMakgora:SetPoint("TOP", f.VSButton, "BOTTOM", 0, -10)
local iconMakgora = btnMakgora:CreateTexture(nil, "BACKGROUND")
iconMakgora:SetTexture("Interface\\Icons\\Ability_Creature_Cursed_02") -- Icône de crâne Vanilla
iconMakgora:SetAllPoints(btnMakgora)
iconMakgora:SetVertexColor(0.3, 0.3, 0.3) -- Grisé par défaut
btnMakgora.icon = iconMakgora
local lblMakgora = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
lblMakgora:SetPoint("TOP", btnMakgora, "BOTTOM", 0, -2)
lblMakgora:SetText("Mak'gora")
lblMakgora:SetTextColor(0.5, 0.5, 0.5)
btnMakgora.lbl = lblMakgora
btnMakgora:SetScript("OnClick", function()
    if FCM_Database.etape > 1 then 
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_CHANGE_MODE_LOCKED"))
        return 
    end 
    FCM_Database.isMakgora = not FCM_Database.isMakgora
    f.RefreshUI()
end)

-- --- HISTORIQUE DYNAMIQUE (AVEC SCROLL) ---
f.ScrollFrame = CreateFrame("ScrollFrame", "FCM_ScrollFrame", f, "UIPanelScrollFrameTemplate")
f.ScrollFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 25, -290)
f.ScrollFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -45, 105)

f.ScrollChild = CreateFrame("Frame", "FCM_ScrollChild", f.ScrollFrame)
f.ScrollChild:SetWidth(480)
f.ScrollChild:SetHeight(10) -- Sera ajusté dynamiquement plus bas

f.ListeText = f.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
f.ListeText:SetPoint("TOP", f.ScrollChild, "TOP", 0, 0)
f.ListeText:SetWidth(480)
f.ListeText:SetJustifyH("CENTER") f.ListeText:SetJustifyV("TOP")
f.ListeText:SetTextColor(1, 1, 1)

f.ListeTextA = f.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
f.ListeTextA:SetPoint("TOPLEFT", f.ListeText, "BOTTOMLEFT", 0, -15)
f.ListeTextA:SetWidth(230)
f.ListeTextA:SetJustifyH("LEFT") f.ListeTextA:SetJustifyV("TOP")
f.ListeTextA:SetTextColor(1, 1, 1)

f.ListeTextB = f.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
f.ListeTextB:SetPoint("TOPRIGHT", f.ListeText, "BOTTOMRIGHT", 0, -15)
f.ListeTextB:SetWidth(230)
f.ListeTextB:SetJustifyH("RIGHT") f.ListeTextB:SetJustifyV("TOP")
f.ListeTextB:SetTextColor(1, 1, 1)

f.SeparatorLine = f.ScrollChild:CreateTexture(nil, "BACKGROUND")
f.SeparatorLine:SetTexture(1, 1, 1, 0.15)
f.SeparatorLine:SetWidth(2)
f.SeparatorLine:SetPoint("TOP", f.ListeText, "BOTTOM", 0, -15)

f.ScrollFrame:SetScrollChild(f.ScrollChild)

-- --- BARRE DE BOUTONS ---
f.BagButton = CreateFrame("Button", "FCM_BtnBag", f)
f.BagButton:SetWidth(42) f.BagButton:SetHeight(42)
f.BagButton:SetPoint("BOTTOM", f, "BOTTOM", 0, 60)

f.BagIcon = f.BagButton:CreateTexture(nil, "OVERLAY")
f.BagIcon:SetTexture("Interface\\Icons\\INV_Misc_Coin_02")
f.BagIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
f.BagIcon:SetAllPoints(f.BagButton)

local highlightBag = f.BagButton:CreateTexture(nil, "HIGHLIGHT")
highlightBag:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
highlightBag:SetBlendMode("ADD")
highlightBag:SetAllPoints(f.BagButton)

local btnRAZ = CreateFrame("Button", "FCM_BtnRAZ", f, "UIPanelButtonTemplate")
btnRAZ:SetWidth(110) btnRAZ:SetHeight(28)
btnRAZ:SetPoint("BOTTOM", f, "BOTTOM", 0, 20)
btnRAZ:SetText("RAZ")
btnRAZ:GetFontString():SetTextColor(0.8, 0.7, 0.2)

local btnPariA = CreateFrame("Button", "FCM_BtnPariA", f, "UIPanelButtonTemplate")
btnPariA:SetWidth(110) btnPariA:SetHeight(28) btnPariA:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 20)

local btnPariB = CreateFrame("Button", "FCM_BtnPariB", f, "UIPanelButtonTemplate")
btnPariB:SetWidth(110) btnPariB:SetHeight(28) btnPariB:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -25, 20)

-- Bouton de paiement unique postal simplifié
local btnPayerPostal = CreateFrame("Button", "FCM_BtnPayerPostal", f, "UIPanelButtonTemplate")
btnPayerPostal:SetWidth(200) btnPayerPostal:SetHeight(28) btnPayerPostal:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -25, 20)
btnPayerPostal:SetText("Préparer Mandat Postal")
btnPayerPostal:GetFontString():SetTextColor(0.1, 0.7, 0.1)

-- --- GESTION DES ONGLETS ET DE LA TRÉSORERIE ---
f.ActiveTab = 1

f.CombatElements = {
    f.StepText, modelA, f.IconClassA, f.NomAText, f.TotalAText, f.CoteAText, btnSetA, btnWinA,
    f.VSButton, modelB, f.IconClassB, f.NomBText, f.TotalBText, f.CoteBText, btnSetB, btnWinB,
    line, lblMontant, ebG, lblG, texG, btnPlusG, btnMinusG,
    ebS, lblS, texS, btnPlusS, btnMinusS, ebC, lblC, texC, btnPlusC, btnMinusC, btnTrade,
    btnMakgora, lblMakgora,
    f.ScrollFrame, f.BagButton, btnRAZ, btnPariA, btnPariB, btnPayerPostal
}

f.Tab1 = CreateFrame("Button", "FCM_Tab1", f)
f.Tab1:SetWidth(32) f.Tab1:SetHeight(32)
f.Tab1:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, -60)
local t1bg = f.Tab1:CreateTexture(nil, "BACKGROUND")
t1bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
t1bg:SetWidth(64) t1bg:SetHeight(64)
t1bg:SetPoint("TOPLEFT", f.Tab1, "TOPLEFT", -3, 11)
f.Tab1:SetNormalTexture("Interface\\Icons\\Ability_Warrior_Challange")
f.Tab1:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
f.Tab1:GetHighlightTexture():SetBlendMode("ADD")

f.Tab2 = CreateFrame("Button", "FCM_Tab2", f)
f.Tab2:SetWidth(32) f.Tab2:SetHeight(32)
f.Tab2:SetPoint("TOPLEFT", f.Tab1, "BOTTOMLEFT", 0, -15)
local t2bg = f.Tab2:CreateTexture(nil, "BACKGROUND")
t2bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
t2bg:SetWidth(64) t2bg:SetHeight(64)
t2bg:SetPoint("TOPLEFT", f.Tab2, "TOPLEFT", -3, 11)
f.Tab2:SetNormalTexture("Interface\\Icons\\INV_Misc_Coin_02")
f.Tab2:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
f.Tab2:GetHighlightTexture():SetBlendMode("ADD")

f.Tab3 = CreateFrame("Button", "FCM_Tab3", f)
f.Tab3:SetWidth(32) f.Tab3:SetHeight(32)
f.Tab3:SetPoint("TOPLEFT", f.Tab2, "BOTTOMLEFT", 0, -15)
local t3bg = f.Tab3:CreateTexture(nil, "BACKGROUND")
t3bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
t3bg:SetWidth(64) t3bg:SetHeight(64)
t3bg:SetPoint("TOPLEFT", f.Tab3, "TOPLEFT", -3, 11)
f.Tab3:SetNormalTexture("Interface\\Icons\\INV_Scroll_03")
f.Tab3:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
f.Tab3:GetHighlightTexture():SetBlendMode("ADD")

f.Tab4 = CreateFrame("Button", "FCM_Tab4", f)
f.Tab4:SetWidth(32) f.Tab4:SetHeight(32)
f.Tab4:SetPoint("TOPLEFT", f.Tab3, "BOTTOMLEFT", 0, -15)
local t4bg = f.Tab4:CreateTexture(nil, "BACKGROUND")
t4bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
t4bg:SetWidth(64) t4bg:SetHeight(64)
t4bg:SetPoint("TOPLEFT", f.Tab4, "TOPLEFT", -3, 11)
f.Tab4:SetNormalTexture("Interface\\Icons\\INV_Misc_Book_09")
f.Tab4:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
f.Tab4:GetHighlightTexture():SetBlendMode("ADD")

f.Tab5 = CreateFrame("Button", "FCM_Tab5", f)
f.Tab5:SetWidth(32) f.Tab5:SetHeight(32)
f.Tab5:SetPoint("TOPLEFT", f.Tab4, "BOTTOMLEFT", 0, -15)
local t5bg = f.Tab5:CreateTexture(nil, "BACKGROUND")
t5bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
t5bg:SetWidth(64) t5bg:SetHeight(64)
t5bg:SetPoint("TOPLEFT", f.Tab5, "TOPLEFT", -3, 11)
f.Tab5:SetNormalTexture("Interface\\Icons\\Ability_Creature_Cursed_02")
f.Tab5:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
f.Tab5:GetHighlightTexture():SetBlendMode("ADD")

f.TreasuryFrame = CreateFrame("Frame", "FCM_TreasuryFrame", f)
f.TreasuryFrame:SetWidth(400) f.TreasuryFrame:SetHeight(400)
f.TreasuryFrame:SetPoint("TOP", f, "TOP", 0, -100)
f.TreasuryFrame:Hide()

f.TreasuryTitle = f.TreasuryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
f.TreasuryTitle:SetPoint("CENTER", f.TreasuryFrame, "CENTER", 0, 40)

f.TreasuryAmountText = f.TreasuryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
f.TreasuryAmountText:SetPoint("TOP", f.TreasuryTitle, "BOTTOM", 0, -30)

local btnResetTreasury = CreateFrame("Button", "FCM_BtnResetTreasury", f.TreasuryFrame, "UIPanelButtonTemplate")
btnResetTreasury:SetWidth(150) btnResetTreasury:SetHeight(28) btnResetTreasury:SetPoint("BOTTOM", f.TreasuryFrame, "BOTTOM", 0, 20)
btnResetTreasury:GetFontString():SetTextColor(0.8, 0.7, 0.2)
btnResetTreasury:SetScript("OnClick", function()
    StaticPopup_Show("FCM_CONFIRM_RESET_TREASURY", FCM_L("CONFIRM_RESET_TREASURY_TEXT"))
end)

f.Tab1:SetScript("OnClick", function() f.ActiveTab = 1; f.RefreshUI(); end)
f.Tab2:SetScript("OnClick", function() f.ActiveTab = 2; f.RefreshUI(); end)
f.Tab3:SetScript("OnClick", function() f.ActiveTab = 3; f.RefreshUI(); end)
f.Tab4:SetScript("OnClick", function() f.ActiveTab = 4; f.RefreshUI(); end)
f.Tab5:SetScript("OnClick", function() f.ActiveTab = 5; f.RefreshUI(); end)

f.RulesFrame = CreateFrame("Frame", "FCM_RulesFrame", f)
f.RulesFrame:SetAllPoints(f)
f.RulesFrame:Hide()

f.RulesTitle = f.RulesFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
f.RulesTitle:SetPoint("TOP", f.RulesFrame, "TOP", 0, -80)

f.RulesScrollFrame = CreateFrame("ScrollFrame", "FCM_RulesScrollFrame", f.RulesFrame, "UIPanelScrollFrameTemplate")
f.RulesScrollFrame:SetPoint("TOPLEFT", f.RulesFrame, "TOPLEFT", 25, -115)
f.RulesScrollFrame:SetPoint("BOTTOMRIGHT", f.RulesFrame, "BOTTOMRIGHT", -45, 20)

f.RulesScrollChild = CreateFrame("Frame", "FCM_RulesScrollChild", f.RulesScrollFrame)
f.RulesScrollChild:SetWidth(480)
f.RulesScrollChild:SetHeight(10)

f.RulesText = f.RulesScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.RulesText:SetPoint("TOPLEFT", f.RulesScrollChild, "TOPLEFT", 5, 0)
f.RulesText:SetWidth(470)
f.RulesText:SetJustifyH("LEFT")
f.RulesText:SetJustifyV("TOP")

f.RulesScrollFrame:SetScrollChild(f.RulesScrollChild)

f.HistoryFrame = CreateFrame("Frame", "FCM_HistoryFrame", f)
f.HistoryFrame:SetAllPoints(f)
f.HistoryFrame:Hide()

f.HistoryScrollFrame = CreateFrame("ScrollFrame", "FCM_HistoryScrollFrame", f.HistoryFrame, "UIPanelScrollFrameTemplate")
f.HistoryScrollFrame:SetPoint("TOPLEFT", f.HistoryFrame, "TOPLEFT", 25, -70)
f.HistoryScrollFrame:SetPoint("BOTTOMRIGHT", f.HistoryFrame, "BOTTOMRIGHT", -45, 60)

f.HistoryScrollChild = CreateFrame("Frame", "FCM_HistoryScrollChild", f.HistoryScrollFrame)
f.HistoryScrollChild:SetWidth(480)
f.HistoryScrollChild:SetHeight(10)

f.HistoryText = f.HistoryScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.HistoryText:SetPoint("TOPLEFT", f.HistoryScrollChild, "TOPLEFT", 0, 0)
f.HistoryText:SetWidth(480)
f.HistoryText:SetJustifyH("LEFT")
f.HistoryText:SetJustifyV("TOP")

f.HistoryScrollFrame:SetScrollChild(f.HistoryScrollChild)

local btnPayerHisto = CreateFrame("Button", "FCM_BtnPayerHisto", f.HistoryFrame, "UIPanelButtonTemplate")
btnPayerHisto:SetWidth(220) btnPayerHisto:SetHeight(28) btnPayerHisto:SetPoint("BOTTOMLEFT", f.HistoryFrame, "BOTTOMLEFT", 30, 20)
btnPayerHisto:GetFontString():SetTextColor(0.1, 0.7, 0.1)
btnPayerHisto:SetScript("OnClick", function()
    for _, match in ipairs(FCM_Database.historique or {}) do
        for pseudo, gain in pairs(match.gainsCalcules) do
            if not match.gainsPayes[pseudo] then
                if EnvoyerCourrierGagnant(pseudo, gain) then
                    match.gainsPayes[pseudo] = true
                    f.RefreshUI()
                end
                return
            end
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_SUCCESS_PREFIX") .. FCM_L("SUCCESS_ALL_PAID"))
end)

local btnResetAllHisto = CreateFrame("Button", "FCM_BtnResetAllHisto", f.HistoryFrame, "UIPanelButtonTemplate")
btnResetAllHisto:SetWidth(110) btnResetAllHisto:SetHeight(28)
btnResetAllHisto:SetPoint("BOTTOMRIGHT", f.HistoryFrame, "BOTTOMRIGHT", -30, 20)
btnResetAllHisto:GetFontString():SetTextColor(0.8, 0.2, 0.2)
btnResetAllHisto:SetScript("OnClick", function()
    StaticPopup_Show("FCM_CONFIRM_DELETE_ALL_HISTORY", FCM_L("CONFIRM_DELETE_ALL_HISTORY_TEXT"))
end)

local btnResetPaidHisto = CreateFrame("Button", "FCM_BtnResetPaidHisto", f.HistoryFrame, "UIPanelButtonTemplate")
btnResetPaidHisto:SetWidth(110) btnResetPaidHisto:SetHeight(28)
btnResetPaidHisto:SetPoint("RIGHT", btnResetAllHisto, "LEFT", -10, 0)
btnResetPaidHisto:GetFontString():SetTextColor(0.8, 0.7, 0.2)
btnResetPaidHisto:SetScript("OnClick", function()
    local nouvelHistorique = {}
    local matchsEffaces = 0
    for _, match in ipairs(FCM_Database.historique or {}) do
        local toutPaye = true
        for pseudo, gain in pairs(match.gainsCalcules) do
            if not match.gainsPayes[pseudo] then 
                toutPaye = false
                break
            end
        end
        if toutPaye then 
            matchsEffaces = matchsEffaces + 1
        else 
            table.insert(nouvelHistorique, match)
        end
    end
    FCM_Database.historique = nouvelHistorique
    DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_SUCCESS_PREFIX") .. string.format(FCM_L("SUCCESS_HISTORY_CLEARED_PAID"), matchsEffaces))
    f.RefreshUI()
end)

f.HoFFrame = CreateFrame("Frame", "FCM_HoFFrame", f)
f.HoFFrame:SetAllPoints(f)
f.HoFFrame:Hide()

f.HoFScrollFrame = CreateFrame("ScrollFrame", "FCM_HoFScrollFrame", f.HoFFrame, "UIPanelScrollFrameTemplate")
f.HoFScrollFrame:SetPoint("TOPLEFT", f.HoFFrame, "TOPLEFT", 25, -70)
f.HoFScrollFrame:SetPoint("BOTTOMRIGHT", f.HoFFrame, "BOTTOMRIGHT", -45, 60)

f.HoFScrollChild = CreateFrame("Frame", "FCM_HoFScrollChild", f.HoFScrollFrame)
f.HoFScrollChild:SetWidth(480)
f.HoFScrollChild:SetHeight(10)

f.HoFTextClassic = f.HoFScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.HoFTextClassic:SetPoint("TOPLEFT", f.HoFScrollChild, "TOPLEFT", 0, 0)
f.HoFTextClassic:SetWidth(230)
f.HoFTextClassic:SetJustifyH("LEFT")
f.HoFTextClassic:SetJustifyV("TOP")

f.HoFTextMakgora = f.HoFScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.HoFTextMakgora:SetPoint("TOPRIGHT", f.HoFScrollChild, "TOPRIGHT", 0, 0)
f.HoFTextMakgora:SetWidth(230)
f.HoFTextMakgora:SetJustifyH("LEFT")
f.HoFTextMakgora:SetJustifyV("TOP")

f.HoFScrollFrame:SetScrollChild(f.HoFScrollChild)

local btnResetHoF = CreateFrame("Button", "FCM_BtnResetHoF", f.HoFFrame, "UIPanelButtonTemplate")
btnResetHoF:SetWidth(200) btnResetHoF:SetHeight(28) btnResetHoF:SetPoint("BOTTOM", f.HoFFrame, "BOTTOM", 0, 20)
btnResetHoF:GetFontString():SetTextColor(0.8, 0.2, 0.2)
btnResetHoF:SetScript("OnClick", function()
    StaticPopup_Show("FCM_CONFIRM_DELETE_HOF", FCM_L("CONFIRM_DELETE_HOF_TEXT"))
end)

----------------------------------------------------
-- SYSTEME DE RAFRAICHISSEMENT
----------------------------------------------------
f.RefreshUI = function()
    -- Mise à jour des textes de base selon la langue
    if FCM_BtnLang then FCM_BtnLang:SetText(string.upper(FCM_Database.lang or "fr")) end
    btnSetA:SetText(FCM_L("BTN_TARGET_A"))
    btnSetB:SetText(FCM_L("BTN_TARGET_B"))
    btnWinA:SetText(FCM_L("BTN_WINNER"))
    btnWinB:SetText(FCM_L("BTN_WINNER"))
    lblMontant:SetText(FCM_L("LBL_BET"))
    btnTrade:SetText(FCM_L("BTN_TRADE"))
    btnRAZ:SetText(FCM_L("BTN_RESET"))
    btnPayerPostal:SetText(FCM_L("BTN_POSTAL"))
    btnPayerHisto:SetText(FCM_L("BTN_PAY_HISTO"))
    btnResetPaidHisto:SetText(FCM_L("BTN_RESET_PAID_HISTO"))
    btnResetAllHisto:SetText(FCM_L("BTN_RESET_ALL_HISTO"))
    btnResetHoF:SetText(FCM_L("BTN_RESET_HOF"))
    btnResetTreasury:SetText(FCM_L("BTN_RESET_TREASURY"))
    if lblMakgora then lblMakgora:SetText(FCM_L("BTN_MAKGORA")) end

    -- GESTION DES ONGLETS
    if f.ActiveTab == 5 then
        for _, el in ipairs(f.CombatElements) do 
            if el then el:Hide() end 
        end
        f.TreasuryFrame:Hide()
        f.RulesFrame:Hide()
        f.HistoryFrame:Hide()
        f.HoFFrame:Show()
        f.MainTitle:SetText(FCM_L("TITLE_HOF"))
        
        local txtC = FCM_L("HOF_CLASSIC_HEADER") .. "\n\n"
        local txtM = FCM_L("HOF_MAKGORA_HEADER") .. "\n\n"
        
        if not FCM_Database.hallOfFame or not next(FCM_Database.hallOfFame) then
            txtC = txtC .. FCM_L("HOF_NO_CHAMPION")
            txtM = txtM .. FCM_L("HOF_NO_CHAMPION")
        else
            local sortedClassic = {}
            local sortedMakgora = {}
            for name, stats in pairs(FCM_Database.hallOfFame) do
                if (stats.classic or 0) > 0 then table.insert(sortedClassic, { name = name, score = stats.classic }) end
                if (stats.makgora or 0) > 0 then table.insert(sortedMakgora, { name = name, score = stats.makgora }) end
            end
            table.sort(sortedClassic, function(a, b) return a.score > b.score end)
            table.sort(sortedMakgora, function(a, b) return a.score > b.score end)

            if table.getn(sortedClassic) == 0 then txtC = txtC .. FCM_L("HOF_NO_CHAMPION_TYPE") end
            for i, fighter in ipairs(sortedClassic) do
                txtC = txtC .. string.format("|cff2095f3%d.|r %s : |cff00ff00%s|r\n", i, fighter.name, string.format(FCM_L("HOF_VICTORIES"), fighter.score))
            end
            if table.getn(sortedMakgora) == 0 then txtM = txtM .. FCM_L("HOF_NO_CHAMPION_TYPE") end
            for i, fighter in ipairs(sortedMakgora) do
                txtM = txtM .. string.format("|cff2095f3%d.|r %s : |cffff0000%s|r\n", i, fighter.name, string.format(FCM_L("HOF_VICTORIES"), fighter.score))
            end
        end
        f.HoFTextClassic:SetText(txtC)
        f.HoFTextMakgora:SetText(txtM)
        f.HoFScrollChild:SetHeight(math.max(f.HoFTextClassic:GetHeight() or 10, f.HoFTextMakgora:GetHeight() or 10) + 20)
        return -- Arrête le rafraichissement de l'interface de combat ici
    elseif f.ActiveTab == 4 then
        for _, el in ipairs(f.CombatElements) do 
            if el then el:Hide() end 
        end
        f.TreasuryFrame:Hide()
        f.RulesFrame:Hide()
        f.HoFFrame:Hide()
        f.HistoryFrame:Show()
        f.MainTitle:SetText(FCM_L("TITLE_HIST"))
        
        local txt = ""
        if not FCM_Database.historique or table.getn(FCM_Database.historique) == 0 then
            txt = FCM_L("HISTORY_NO_MATCH")
        else
            for _, match in ipairs(FCM_Database.historique) do
                txt = txt .. string.format(FCM_L("HISTORY_MATCH_DATE"), (match.date or "?")) .. "\n"
                txt = txt .. string.format(FCM_L("HISTORY_MATCH_INFO"), match.nomA, match.nomB, match.vainqueur) .. "\n"
                local hasGains = false
                for pseudo, gain in pairs(match.gainsCalcules) do
                    hasGains = true
                    local statut = match.gainsPayes[pseudo] and FCM_L("STATUS_PAID") or FCM_L("STATUS_UNPAID")
                    local pseudoAffiche = pseudo
                    if (pseudo == match.nomA or pseudo == match.nomB) and string.find(match.vainqueur, pseudo, 1, true) == 1 then
                        pseudoAffiche = string.format(FCM_L("FIGHTER_TAG"), pseudo)
                    end
                    txt = txt .. string.format("  • %s -> %s %s\n", pseudoAffiche, FormaterArgent(gain), statut)
                end
                if not hasGains then
                    txt = txt .. FCM_L("HISTORY_NO_GAINS") .. "\n"
                end
                txt = txt .. "\n"
            end
        end
        f.HistoryText:SetText(txt)
        f.HistoryScrollChild:SetHeight(f.HistoryText:GetHeight() + 20)
        return -- Arrête le rafraichissement de l'interface de combat ici
    elseif f.ActiveTab == 3 then
        for _, el in ipairs(f.CombatElements) do 
            if el then el:Hide() end 
        end
        f.TreasuryFrame:Hide()
        f.HistoryFrame:Hide()
        f.HoFFrame:Hide()
        f.RulesFrame:Show()
        f.MainTitle:SetText(FCM_L("TITLE_RULES"))
        f.RulesTitle:SetText(FCM_L("TITLE_RULES_HEADER"))
        f.RulesText:SetText(FCM_L("RULES_TEXT"))
        f.RulesScrollChild:SetHeight(f.RulesText:GetHeight() + 20)
        return
    elseif f.ActiveTab == 2 then
        for _, el in ipairs(f.CombatElements) do 
            if el then el:Hide() end 
        end
        f.TreasuryFrame:Show()
        f.RulesFrame:Hide()
        f.HistoryFrame:Hide()
        f.HoFFrame:Hide()
        f.MainTitle:SetText(FCM_L("TITLE_TREASURY"))
        f.TreasuryTitle:SetText(FCM_L("TITLE_TREASURY_TAXES"))
        if f.TreasuryAmountText then
            f.TreasuryAmountText:SetText(FormaterArgent(FCM_Database.tresorerie or 0))
        end
        return -- Arrête le rafraichissement de l'interface de combat ici
    else
        f.TreasuryFrame:Hide()
        f.RulesFrame:Hide()
        f.HistoryFrame:Hide()
        f.HoFFrame:Hide()
        f.MainTitle:SetText(FCM_L("TITLE_MAIN"))
        for _, el in ipairs(f.CombatElements) do 
            if el then el:Show() end 
        end
    end

    if FCM_BtnMakgora then
        if FCM_Database.isMakgora then
            FCM_BtnMakgora.icon:SetVertexColor(1, 1, 1)
            FCM_BtnMakgora.lbl:SetTextColor(1, 0, 0)
        else
            FCM_BtnMakgora.icon:SetVertexColor(0.3, 0.3, 0.3)
            FCM_BtnMakgora.lbl:SetTextColor(0.5, 0.5, 0.5)
        end
    end

    local dispNomA = FCM_Database.nomA .. (FCM_Database.levelA and string.format(FCM_L("LEVEL_TAG"), FCM_Database.levelA) or "")
    local dispNomB = FCM_Database.nomB .. (FCM_Database.levelB and string.format(FCM_L("LEVEL_TAG"), FCM_Database.levelB) or "")

    f.NomAText:SetText("|cffffffff" .. dispNomA .. "|r")
    f.NomBText:SetText("|cffffffff" .. dispNomB .. "|r")

    if FCM_Database.classA and CLASS_ICON_TCOORDS[FCM_Database.classA] then
        f.IconClassA:Show()
        f.IconClassA:SetTexCoord(unpack(CLASS_ICON_TCOORDS[FCM_Database.classA]))
        f.NomAText:SetPoint("TOPLEFT", f, "TOPLEFT", 140, -65)
        f.TotalAText:SetPoint("TOPLEFT", f, "TOPLEFT", 140, -110)
        f.CoteAText:SetPoint("TOPLEFT", f, "TOPLEFT", 140, -130)
    else
        f.IconClassA:Hide()
        -- Si pas d'icône, on rapproche tout le texte de l'avatar pour que ce soit propre
        f.NomAText:SetPoint("TOPLEFT", f, "TOPLEFT", 115, -65)
        f.TotalAText:SetPoint("TOPLEFT", f, "TOPLEFT", 115, -110)
        f.CoteAText:SetPoint("TOPLEFT", f, "TOPLEFT", 115, -130)
    end

    if FCM_Database.classB and CLASS_ICON_TCOORDS[FCM_Database.classB] then
        f.IconClassB:Show()
        f.IconClassB:SetTexCoord(unpack(CLASS_ICON_TCOORDS[FCM_Database.classB]))
        f.NomBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -140, -65)
        f.TotalBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -140, -110)
        f.CoteBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -140, -130)
    else
        f.IconClassB:Hide()
        -- Si pas d'icône, on rapproche tout le texte de l'avatar pour que ce soit propre
        f.NomBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -115, -65)
        f.TotalBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -115, -110)
        f.CoteBText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -115, -130)
    end

    f.TotalAText:SetText(FCM_L("TXT_BETS") .. FormaterArgent(FCM_Database.totalA))
    f.TotalBText:SetText(FCM_L("TXT_BETS") .. FormaterArgent(FCM_Database.totalB))
    
    -- Affiche dynamiquement le nom des protagonistes sur les boutons de pari
    local nomCourtA = string.len(FCM_Database.nomA) > 8 and string.sub(FCM_Database.nomA, 1, 7) .. "." or FCM_Database.nomA
    local nomCourtB = string.len(FCM_Database.nomB) > 8 and string.sub(FCM_Database.nomB, 1, 7) .. "." or FCM_Database.nomB
    btnPariA:SetText(FCM_L("TXT_BET_ON") .. nomCourtA)
    btnPariB:SetText(FCM_L("TXT_BET_ON") .. nomCourtB)

    local totalGlobal = FCM_Database.totalA + FCM_Database.totalB
    local tauxTaxe = FCM_Database.isMakgora and 0.30 or 0.15
    local cagnotteApresTaxe = totalGlobal * (1 - tauxTaxe)
    local coteA, coteB = 1.00, 1.00
    if FCM_Database.totalA > 0 then coteA = cagnotteApresTaxe / FCM_Database.totalA end
    if FCM_Database.totalB > 0 then coteB = cagnotteApresTaxe / FCM_Database.totalB end
    if coteA < 1.00 then coteA = 1.00 end if coteB < 1.00 then coteB = 1.00 end
    
    f.CoteAText:SetText(FCM_L("TXT_ODDS") .. string.format("|cff%s%.2f|r", ObtenirCouleurCote(coteA), coteA))
    f.CoteBText:SetText(FCM_L("TXT_ODDS") .. string.format("|cff%s%.2f|r", ObtenirCouleurCote(coteB), coteB))

    if FCM_Database.etape == 1 then
        f.StepText:SetText(FCM_L("STEP1"))
        f.BagButton:Hide()
        f.VSIcon:SetVertexColor(0.25, 0.25, 0.25) -- Grisé au départ
        btnRAZ:Show()
        
        btnSetA:Show() btnSetB:Show()
        btnWinA:Hide() btnWinB:Hide()
        btnPariA:Hide() btnPariB:Hide() btnPayerPostal:Hide()
        
        btnPlusG:Hide() btnMinusG:Hide() btnPlusS:Hide() btnMinusS:Hide() btnPlusC:Hide() btnMinusC:Hide()
        ebG:Hide() ebS:Hide() ebC:Hide()
        btnTrade:Hide()

    elseif FCM_Database.etape == 2 then
        f.StepText:SetText(FCM_L("STEP2"))
        f.BagButton:Show()
        f.BagIcon:SetVertexColor(0.25, 0.25, 0.25) -- Grisé
        f.VSIcon:SetVertexColor(1.0, 1.0, 1.0) -- En couleurs
        btnRAZ:Show()
        
        btnSetA:Hide() btnSetB:Hide()
        btnWinA:Hide() btnWinB:Hide()
        btnPariA:Show() btnPariB:Show() btnPayerPostal:Hide()
        
        btnPlusG:Show() btnMinusG:Show() btnPlusS:Show() btnMinusS:Show() btnPlusC:Show() btnMinusC:Show()
        ebG:Show() ebS:Show() ebC:Show()
        btnTrade:Show()

    elseif FCM_Database.etape == 3 then
        f.StepText:SetText(FCM_L("STEP3"))
        f.BagButton:Show()
        f.BagIcon:SetVertexColor(1.0, 1.0, 1.0) -- En couleurs
        f.VSIcon:SetVertexColor(1.0, 1.0, 1.0)
        btnRAZ:Show()
        
        btnSetA:Hide() btnSetB:Hide()
        btnPariA:Hide() btnPariB:Hide() btnPayerPostal:Hide()
        
        btnPlusG:Hide() btnMinusG:Hide() btnPlusS:Hide() btnMinusS:Hide() btnPlusC:Hide() btnMinusC:Hide()
        ebG:Hide() ebS:Hide() ebC:Hide()
        btnTrade:Hide()
        
        btnWinA:Show() btnWinB:Show()

    elseif FCM_Database.etape == 4 then
        f.StepText:SetText(FCM_L("STEP4"))
        f.BagButton:Show()
        f.BagIcon:SetVertexColor(1.0, 1.0, 1.0) -- En couleurs
        f.VSIcon:SetVertexColor(1.0, 1.0, 1.0)
        btnRAZ:Show()
        btnRAZ:SetText(FCM_L("BTN_MATCH_DONE"))
        
        btnSetA:Hide() btnSetB:Hide()
        btnWinA:Hide() btnWinB:Hide()
        btnPariA:Hide() btnPariB:Hide()
        
        btnPlusG:Hide() btnMinusG:Hide() btnPlusS:Hide() btnMinusS:Hide() btnPlusC:Hide() btnMinusC:Hide()
        ebG:Hide() ebS:Hide() ebC:Hide()
        btnTrade:Hide()
        
        btnPayerPostal:Hide() 
    end

    local txtTitle = ""
    local txtA = ""
    local txtB = ""
    local hasGains = false
    for k, v in pairs(FCM_Database.gainsCalcules) do hasGains = true; break; end

    if hasGains then
        txtTitle = FCM_L("WINNERS_LIST_TITLE")
        f.SeparatorLine:Hide()
        f.ListeTextB:Hide()
        f.ListeTextA:SetWidth(470)
        f.ListeTextA:SetJustifyH("LEFT")
        f.ListeTextA:SetPoint("TOPLEFT", f.ListeText, "BOTTOMLEFT", 0, -15)
        
        for pseudo, gain in pairs(FCM_Database.gainsCalcules) do
            local statut = (FCM_Database.gainsPayes and FCM_Database.gainsPayes[pseudo]) and FCM_L("STATUS_PAID") or FCM_L("STATUS_UNPAID")
            local pseudoAffiche = pseudo
            if pseudo == FCM_Database.nomA or pseudo == FCM_Database.nomB then
                pseudoAffiche = string.format(FCM_L("FIGHTER_TAG"), pseudo)
            end
            txtA = txtA .. string.format("  • %s  ->  %s %s\n", pseudoAffiche, FormaterArgent(gain), statut)
        end
    else
        txtTitle = FCM_L("BETS_REGISTER_TITLE")
        f.SeparatorLine:Show()
        f.ListeTextB:Show()
        f.ListeTextA:SetWidth(225)
        f.ListeTextA:SetJustifyH("LEFT")
        f.ListeTextA:SetPoint("TOPLEFT", f.ListeText, "BOTTOMLEFT", 0, -15)
        f.ListeTextB:SetWidth(225)
        f.ListeTextB:SetJustifyH("RIGHT")
        f.ListeTextB:SetPoint("TOPRIGHT", f.ListeText, "BOTTOMRIGHT", 0, -15)

        txtA = "|cff2095f3" .. string.sub(FCM_Database.nomA, 1, 12) .. "|r\n\n"
        txtB = "|cff2095f3" .. string.sub(FCM_Database.nomB, 1, 12) .. "|r\n\n"

        for pseudo, data in pairs(FCM_Database.parieurs) do
            -- Affichage distinct des mises sur A et sur B pour un même joueur
            if data.miseA > 0 then
                txtA = txtA .. string.format("%s : %s\n", pseudo, FormaterArgent(data.miseA))
            end
            if data.miseB > 0 then
                txtB = txtB .. string.format("%s : %s\n", FormaterArgent(data.miseB), pseudo)
            end
        end
    end
    f.ListeText:SetText(txtTitle)
    f.ListeTextA:SetText(txtA)
    f.ListeTextB:SetText(txtB)
    
    local hTitle = f.ListeText:GetHeight() or 10
    local hA = f.ListeTextA:GetHeight() or 10
    local hB = f.ListeTextB:GetHeight() or 10
    local maxH = (hA > hB) and hA or hB
    
    f.SeparatorLine:SetHeight(maxH)

    -- Ajuster la hauteur de la zone de défilement en fonction de la taille réelle du texte généré
    f.ScrollChild:SetHeight(hTitle + maxH + 30)

    -- Mise à jour de la trésorerie affichée
    if f.SidePanel and f.SidePanel:IsShown() then
        f.SidePanel.Amount:SetText(FormaterArgent(FCM_Database.tresorerie or 0))
    end
end

----------------------------------------------------
-- INTERACTIONS BOUTONS
----------------------------------------------------
f.VSButton:SetScript("OnClick", function()
    if FCM_Database.etape == 1 then
        if FCM_Database.nomA == FCM_L("BTN_TARGET_A") or FCM_Database.nomB == FCM_L("BTN_TARGET_B") then
            DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_REGISTER_FIGHTERS"))
            return
        end
        FCM_Database.etape = 2
        f.RefreshUI()
    end
end)

f.BagButton:SetScript("OnClick", function()
    if FCM_Database.etape == 2 then
        FCM_Database.etape = 3
        f.RefreshUI()
    end
end)

btnRAZ:SetScript("OnClick", function()
    ResetClub()
end)

btnSetA:SetScript("OnClick", function()
    local name = GetUnitName("target")
    if name and UnitIsPlayer("target") then 
        if name == FCM_Database.nomB then
            DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_ALREADY_FIGHTER_B"))
            return
        end
        local _, class = UnitClass("target")
        local level = UnitLevel("target")
        FCM_Database.nomA = name 
        FCM_Database.classA = class 
        FCM_Database.levelA = level
        modelA:SetUnit("target") 
        f.RefreshUI() 
    else 
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_TARGET_FIGHTER_A")) 
    end
end)

btnSetB:SetScript("OnClick", function()
    local name = GetUnitName("target")
    if name and UnitIsPlayer("target") then 
        if name == FCM_Database.nomA then
            DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_ALREADY_FIGHTER_A"))
            return
        end
        local _, class = UnitClass("target")
        local level = UnitLevel("target")
        FCM_Database.nomB = name 
        FCM_Database.classB = class 
        FCM_Database.levelB = level
        modelB:SetUnit("target") 
        f.RefreshUI() 
    else 
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_TARGET_FIGHTER_B")) 
    end
end)

btnPariA:SetScript("OnClick", function() EnregistrerPari("A", ebG:GetText(), ebS:GetText(), ebC:GetText()) end)
btnPariB:SetScript("OnClick", function() EnregistrerPari("B", ebG:GetText(), ebS:GetText(), ebC:GetText()) end)
btnWinA:SetScript("OnClick", function() CalculerGains("A") end)
btnWinB:SetScript("OnClick", function() CalculerGains("B") end)

btnTrade:SetScript("OnClick", function()
    if UnitExists("target") and UnitIsPlayer("target") then
        InitiateTrade("target")
    else
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_ERROR_PREFIX") .. FCM_L("ERROR_TARGET_FOR_TRADE"))
    end
end)

-- Interaction avec le nouveau bouton postal
btnPayerPostal:SetScript("OnClick", function()
    local nextWinner, nextAmount = nil, nil
    
    -- Trouve le premier gagnant qui n'a pas encore été payé
    for pseudo, gain in pairs(FCM_Database.gainsCalcules) do
        if not (FCM_Database.gainsPayes and FCM_Database.gainsPayes[pseudo]) then
            nextWinner = pseudo
            nextAmount = gain
            break
        end
    end
    
    if nextWinner then
        if EnvoyerCourrierGagnant(nextWinner, nextAmount) then
            if not FCM_Database.gainsPayes then FCM_Database.gainsPayes = {} end
            FCM_Database.gainsPayes[nextWinner] = true
            f.RefreshUI()
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage(FCM_L("CHAT_SUCCESS_PREFIX") .. FCM_L("SUCCESS_ALL_MAIL_PREPARED"))
    end
end)

----------------------------------------------------
-- AUTO-LECTURE DE LA FENÊTRE D'ÉCHANGE
----------------------------------------------------
local tradeWatcher = CreateFrame("Frame")
tradeWatcher:RegisterEvent("TRADE_TARGET_ITEM_CHANGED")
tradeWatcher:RegisterEvent("TRADE_ACCEPT_UPDATE")
tradeWatcher:SetScript("OnEvent", function()
    if FCM_Database.etape == 2 and TradeFrame and TradeFrame:IsShown() then
        local copper = GetTargetTradeMoney() or 0
        local g = math.floor(copper / 10000)
        local s = math.floor(math.mod(copper, 10000) / 100)
        local c = math.mod(copper, 100)
        
        ebG:SetText(tostring(g))
        ebS:SetText(tostring(s))
        ebC:SetText(tostring(c))
    end
end)

----------------------------------------------------
-- DECORRELATION TOTALE DE L'AUTO-TRADE SECRETE
----------------------------------------------------
SLASH_FIGHTCLUB1 = "/fc"
SlashCmdList["FIGHTCLUB"] = function(msg) if f:IsShown() then f:Hide() else f:Show() f.RefreshUI() end end