#Include %A_ScriptDir%\FastNavigation\NavigationItem.ahk
#Include %A_ScriptDir%\FastNavigation\ConfigurationReader.ahk
#Include %A_ScriptDir%\FastNavigation\Items\Common\Common.ahk
#Include %A_ScriptDir%\FastNavigation\Items\CopyFilePathNavigationItem.ahk
#Include %A_ScriptDir%\FastNavigation\Items\Web\Web.ahk
#Include %A_ScriptDir%\FastNavigation\Items\Files.ahk
#Include %A_ScriptDir%\FastNavigation\Items\Shell.ahk
#Include %A_ScriptDir%\FastNavigation\Items\Sitecore\Sitecore.ahk


class FastNavigation extends NavigationItem {
    __New(shortcut, description){

        base.__New(shortcut, description)

        this.rootItem := rootItem
        this.Root := this

        this.Context := {}
        this.titleParse := new WindowTitleParser()

        this.Config := new ConfigurationReader()

        this.GetCurrentEnvironment()
    }

    GetCurrentEnvironment(){
        pattern := this.Config.Common.patterns.info
        info := this.titleParse.GetInfo(pattern)

        Log("Search for current Env... [{1}] Config Dump {2}", [pattern])
        if(info <> "") {
            this.Environment := this.Config.GetEnvironment(info.domain, info.href)
            Log("Current Environment is {1}", [this.Environment.Name])
        }
    }

    AddAllEnvironments(editItems){
        envs := this.Config.Environments
        for index, environment in envs
        {
            envMenu := new EnvironmentNavigationItem(environment).AddItemList(editItems)
            this.AddItem(envMenu)
        }
    }

    AddCommonPages()
    {

    }
}
