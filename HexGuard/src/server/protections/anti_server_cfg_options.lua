local logger = require("server/core/logger")
local ban_manager = require("server/core/ban_manager")

---@class AntiServerCfgOptionsModule
local AntiServerCfgOptions = {}

---@return void This function will apply the server security settings to the server
function AntiServerCfgOptions.initialize()
    -- Check if server security settings are enabled
    if not hexguard.ServerSecurity or not hexguard.ServerSecurity.Enabled then
        logger.info("[hexguard] Server security configuration not enabled")
        return
    end
    
    -- CONNECTION & AUTHENTICATION SETTINGS
    if hexguard.ServerSecurity.Connection then
        -- Timeout settings
        SetConvar("sv_kick_players_cnl_timeout_sec", tostring(hexguard.ServerSecurity.Connection.KickTimeout or 600))
        SetConvar("sv_kick_players_cnl_update_rate_sec", tostring(hexguard.ServerSecurity.Connection.UpdateRate or 60))
        SetConvar("sv_kick_players_cnl_consecutive_failures", tostring(hexguard.ServerSecurity.Connection.ConsecutiveFailures or 2))
        
        -- Authentication settings
        SetConvar("sv_authMaxVariance", tostring(hexguard.ServerSecurity.Connection.AuthMaxVariance or 1))
        SetConvar("sv_authMinTrust", tostring(hexguard.ServerSecurity.Connection.AuthMinTrust or 5))
        
        -- Client verification
        SetConvar("sv_pure_verify_client_settings", hexguard.ServerSecurity.Connection.VerifyClientSettings and "1" or "0")
    end
    
    -- NETWORK EVENT SECURITY
    if hexguard.ServerSecurity.NetworkEvents then
        -- Block REQUEST_CONTROL_EVENT routing (supports values -1 to 4, 2 recommended for your use case)
        SetConvar("sv_filterRequestControl", tostring(hexguard.ServerSecurity.NetworkEvents.FilterRequestControl or 0))
        
        -- Block NETWORK_PLAY_SOUND_EVENT routing
        SetConvar("sv_enableNetworkedSounds", hexguard.ServerSecurity.NetworkEvents.DisableNetworkedSounds and "false" or "true")
        
        -- Block REQUEST_PHONE_EXPLOSION_EVENT
        SetConvar("sv_enableNetworkedPhoneExplosions", hexguard.ServerSecurity.NetworkEvents.DisablePhoneExplosions and "false" or "true")
        
        -- Block SCRIPT_ENTITY_STATE_CHANGE_EVENT
        SetConvar("sv_enableNetworkedScriptEntityStates", hexguard.ServerSecurity.NetworkEvents.DisableScriptEntityStates and "false" or "true")
    end
    
    -- CLIENT MODIFICATION PROTECTION
    if hexguard.ServerSecurity.ClientProtection then
        -- Pure level setting
        SetConvar("sv_pureLevel", tostring(hexguard.ServerSecurity.ClientProtection.PureLevel or 2))
        
        -- Disable client replays
        SetConvar("sv_disableClientReplays", hexguard.ServerSecurity.ClientProtection.DisableClientReplays and "1" or "0")
        
        -- Script hook settings
        SetConvar("sv_scriptHookAllowed", hexguard.ServerSecurity.ClientProtection.ScriptHookAllowed and "1" or "0")
    end
    
    -- MISC SECURITY SETTINGS
    if hexguard.ServerSecurity.Misc then
        -- Enable chat sanitization
        SetConvar("sv_enableChatTextSanitization", hexguard.ServerSecurity.Misc.EnableChatSanitization and "1" or "0")
        
        -- Rate limits
        if hexguard.ServerSecurity.Misc.ResourceKvRateLimit then
            SetConvar("sv_defaultResourceKvRateLimit", tostring(hexguard.ServerSecurity.Misc.ResourceKvRateLimit))
        end
        
        if hexguard.ServerSecurity.Misc.EntityKvRateLimit then
            SetConvar("sv_defaultEntityKvRateLimit", tostring(hexguard.ServerSecurity.Misc.EntityKvRateLimit))
        end
    end
    
    logger.info("[hexguard] Server security configuration applied successfully")
end

return AntiServerCfgOptions