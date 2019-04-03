class ConfigurationReader {
	static configPathFile := A_MyDocuments . "\sitecore.navigation.ini"

    __New(){
        this.FileName := this._GetConfigPath(fileName)
        Log("Loading configuraton from {1}", [this.FileName])
        this._ReadConfiguration()
    }

    GetEnvironment(host, href){
        this._CheckEnvironment(host, href)
        for index, environment in this.Environments
        {
            if(environment.Master.isMatch or environment.Web.isMatch){
                return environment
            }
        }

        return ""
    }

	_GetConfigPath(){
		configIniPath := this.configPathFile

		if (FileExist(configIniPath) <> ""){
			; Log("reading configuration from configPathFile {1}", [configIniPath])
			IniRead, pathToConfig, %configIniPath%, ConfigPath, configPath
			return pathToConfig
		} else {
			InputBox, pathToConfig, Provide a path to navigtion configuration
			if(FileExist(pathToConfig)){
				; Log("Save configuration to configPathFile {1} {2}", [configIniPath, pathToConfig])
				IniWrite, %pathToConfig%, %configIniPath%, ConfigPath, configPath
				return pathToConfig
			} else {
				MsgBox, Config file doesn't exists
			}
		}
	}

    _EnrichEnvironment(){
        mainDomain := this.Common.Versions[1]
        for index, environment in this.Environments
        {
            environment.Web := {}
            environment.Web.Pattern := this._GetDomainPattern(environment, "web")
            environment.Web.Url := this._GetDomainUrl(environment, "web", mainDomain)

            environment.Master := {}
            environment.Master.Pattern := this._GetDomainPattern(environment, "master")
            environment.Master.Url := this._GetDomainUrl(environment, "master", mainDomain)
            ; environment.Computed.Domains.Web := this._GetDomainPattern(environment, "web")
            ; environment.Computed.Domains.Master := this._GetDomainPattern(environment, "master")
        }
    }

    _CheckEnvironment(host, href){
        for index, environment in this.Environments
        {
            position := RegExMatch(host, environment.Web.Pattern)
            environment.Web.isMatch := position > 0
            position := RegExMatch(host, environment.Master.Pattern)
            environment.Master.isMatch := position > 0
            position := RegExMatch(href, this.Common.Domains.Sitecore)
            environment.Computed.isSitecore := position > 0
        }
    }

    _GetDomainUrl(environment, urlType, mainDomain){
        pattern := this.Common.UrlFormat[urlType]
        prefix := ""
        if(environment.UrlFormat[urlType]){
            pattern := environment.UrlFormat[urlType]
        }
        if(environment.params[urlType]){
            prefix := environment.params[urlType]
            pattern := StrReplace(pattern, "{prefix}", prefix)
        }

        pattern := StrReplace(pattern, "{version}", mainDomain)
        ; Log("Config GetDomainUrl {1}", [pattern])
        return pattern
    }

    _GetDomainPattern(environment, urlType){
        pattern := this.Common.Domains[urlType]
        prefix := ""
        if(environment.domains[urlType]){
            pattern := environment.domains[urlType]
        }
        if(environment.params[urlType]){
            prefix := environment.Params[urlType]
            pattern := StrReplace(pattern, "{prefix}", prefix)
        }

        versions := StringJoin(this.Common.Versions, "|")
        pattern := StrReplace(pattern, "{version}", versions)
        ; Log("Config getDomainPattern {1}", [pattern])
        return pattern
    }

    _ReadConfiguration(){
        filePath := this.FileName
        FileRead, FileContent, %filePath%
        ;Log("Config {1}, FilePath {2}", [FileContent, filePath  ])
        this._Configuration := Jxon_Load(fileContent)
        this.Common := this._Configuration.Environments.Common
        this.Environments := this._GetEnvironments()
        this._EnrichEnvironment()
    }

    _GetEnvironments(){
        envList := this._Configuration.environments
        env := [envList.local, envList.test, envList.mstest, envList.uat, envList.prod]
        return env
    }

}
