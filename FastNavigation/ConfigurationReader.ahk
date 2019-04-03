class ConfigurationReader {
	static configPathFile := USERPROFILE . "\sitecore.navigation.ini"
	
    __New(fileName){
        this.FileName := this._GetConfigPath(fileName)
        this._ReadConfiguration()
    }

    GetEnvironment(host, href){
        this._EnrichEnvironment(host, href)
        for index, environment in this.Environments
        {
            if(environment.Computed.isMaster or environment.Computed.isWeb){
                return environment
            }
        }

        return ""
    }
	
	_GetConfigPath(fileName){
		if(fileName <> "") {
			if(FileExist(fileName) <> ""){
				Log("reading configuration from file name {1}", [fileName])
				return fileName
			}
		}
		
		configIniPath := this.configPathFile
	
		if (FileExist(configIniPath) <> ""){
			Log("reading configuration from configPathFile {1}", [configIniPath])
			IniRead, pathToConfig, %configIniPath%, ConfigPath, configPath
			return pathToConfig
		} else {
			InputBox, pathToConfig, Provide a path to navigtion configuration
			if(FileExist(pathToConfig)){
				Log("Save configuration to configPathFile {1} {2}", [configIniPath, pathToConfig])
				IniWrite, %pathToConfig%, %configIniPath%, ConfigPath, configPath
				return pathToConfig
			} else {
				MsgBox, Config file doesn't exists
			}
		}
	}

    _EnrichEnvironment(host, href){
        for index, environment in this.Environments
        {
            environment.Computed := {}
            environment.Computed.Domains := {}
            environment.Computed.Domains.Web := this.GetDomainPattern(environment, "web")
            environment.Computed.Domains.Master := this.GetDomainPattern(environment, "master")

            position := RegExMatch(host, environment.Computed.Domains.Web)
            environment.Computed.isWeb := position > 0
            position := RegExMatch(host, environment.Computed.Domains.Master)
            environment.Computed.isMaster := position > 0
            position := RegExMatch(href, this.Common.Domains.Sitecore)
            environment.Computed.isSitecore := position > 0
        }
    }

    _GetDomainPattern(environment, urlType){
        pattern := this.Common.Domains[urlType]
        prefix := ""
        if(environment.domains[urlType]){
            pattern := environment.domains[urlType]
        }
        if(environment.params[urlType]){
            prefix := environment.params[urlType]
            pattern := StrReplace(pattern, "{prefix}", prefix)
        }

        versions := StringJoin(this.Common.Versions, "|")
        pattern := StrReplace(pattern, "{versions}", versions)
        Log("Config getDomain {1}", [pattern])
        return pattern
    }

    _ReadConfiguration(){
        filePath := this.FileName
        FileRead, FileContent, %filePath%
        ;Log("Config {1}, FilePath {2}", [FileContent, filePath  ])
        this._Configuration := Jxon_Load(fileContent)
        this.Common := this._Configuration.Environments.Common
        this.Environments := this._GetEnvironments()
    }

    _GetEnvironments(){
        envList := this.Config.environments
        env := [envList.local, envList.test, envList.mstest, envList.uat, envList.prod]
        return env
    }

}
