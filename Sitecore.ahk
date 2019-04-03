#Include %A_ScriptDir%\Common\Common.ahk
#Include %A_ScriptDir%\FastNavigation\Navigation.ahk

#Include <Hotkeys>

#Include <Jxon>
#Include <JSON>

; The FileName parameter may optionally be preceded by *i and a single space,
;   which causes the program to ignore any failure to load the included file.
; For example: #Include *i SpecialOptions.ahk.
; This option should be used only when the included file's contents are not essential to the main script's operation.
; #Include *i C:\Project\Project.ahk

+!m::

    Log("============================== Alt + Shift + M =============================", [A_ScriptDir])
    Log("script path {1}", [A_ScriptDir])
    handleLinksMenu()
return

handleLinksMenu(){
    global

    secondLevelItems.Push(new WebsiteMenuItem("j", "JIRA",  config.urls.jira . "/issues/?filter=myopenissues"))
    secondLevelItems.Push(new WebsiteMenuItem("b", "Team City", config.urls.teamcity))
    secondLevelItems.Push(new WebsiteMenuItem("s", "TFS",  config.urls.tfs))

    editItems := []
    editItems.Push(new SeparatorMenuItem())

    editItems.Push(new AddressNavigationItem("t", "Address from current url"))
    editItems.Push(new SeparatorMenuItem())

    editItems.Push(SiteCoreAdminMenu())
    editItems.Push(SiteCoreShellMenu())
    editItems.Push(SiteCoreLogsMenu())

    editItems.Push(new SeparatorMenuItem())
    editItems.Push(GetSolrMenu())
    editItems.Push(new SeparatorMenuItem())

    editItems.Push(OpenItemIn())
    editItems.Push(new SeparatorMenuItem())

    editItems.Push(new NavigationItem("i", "Open Item"))

    secondLevelItems.Push(new CopyFilePathNavigationItem("f"))

    diagnostics := GetDiagnosticFilesOnLocal()


    rootItem := new FastNavigation("m", "Project Navigation", configPath)
        .AddItem(new SeparatorMenuItem())
        .AddAllEnvironments(editItems)
        .AddItem(new SeparatorMenuItem())
        .AddItem(diagnostics)
        .AddItem(GetYankMenu())
        .AddItem(new SeparatorMenuItem())
        .AddItemList(secondLevelItems)
        .AddItem(GetGuidFormat())
        .AddItem(new TranslateItem("q"))
        ; .AddItem(new AppPoolRecycleMenu("r", config.iis.appPool))

    if(rootItem.Environment){
        rootItem.AddItem(new SeparatorMenuItem())
        rootItem.AddItemList(editItems)
    }

    Log("Showing root menu items [{1}]", [rootItem.Description])
    rootItem.ShowCommandsAndLaunchSelected()
}

GetBranchNameFromIssueTitle(){
    WinGetTitle JiraIssueTitle, A
    ; JiraIssueTitle := Trim(Clipboard)
    Slug := StrReplace(JiraIssueTitle, " - ???", "")
    return SlugifyText(Slug)
}

GetIssueNumber(){
    IssueUrl:=CopyBrowserUrl()
    RegExMatch(IssueUrl, "", IssueMatch)
    IssueNumber:=IssueMatch.Value(1) ; Get the matched subpattern "(\d+)"
    return IssueNumber
}



; ; key: Y
; handleCopying(){
;     INPUT, command, T2 L1

;     if ("c" = command){   ; Format Peer review request
;         MsgBox, Foramt Peer review request
;         BranchName:=GetBranchNameFromIssueTitle()

;         IssueUrl:=CopyBrowserUrl()
;         IssueNumber:=GetIssueNumber()
;         IssueUrl:=Format("h, IssueNumber)
;         TfsBranchAddress:=Format("", BranchName)
;         FormatedString:=Format("PeerReview: {1} `n Jira Issue: {2} `n TFS url: {3} ", BranchName, IssueUrl,  TfsBranchAddress)
;         MsgBox, %FormatedString%
;         Clipboard:=FormatedString
;     }
;     else if ("#" = command || "b" = command){
;         Clipboard:= GetIssueNumber()
;     }
; }
