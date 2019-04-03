class NavigationItem {
    SubItems := []

    __New(letter,  description){
        Log("Creating NavigationItem {1} '{2}'", [letter ,description])
        this.Letter := letter
        this.Description := description
        this.Level := 0
    }

    AddItem(newItem){
        Log("Adding item {1} '{2}'", [newItem.Letter ,newItem.Description])
        newItem.Parent := this
        newItem.Level := this.Level + 1
        this.SubItems.Push(newItem)
        return this
    }

    AddItemList(newItemList){
        for index, newItem in newItemList
        {
            this.AddItem(newItem)
        }
        return this
    }

    ShowCommandsAndLaunchSelected(){
        Log("ShowCommandsAndLaunchSelected() ... ", [])
        this.AssignRoot()
        this.ShowHelp()

        INPUT, command, T10 L1 I

        this.HideHelp()
        this.LaunchCommand(command)
    }

    ShowHelp(){
        title := this.GetTitle()
        text := this.GetCommandsList()
        Log("Command list text {1}", [text])
        this.ShowSplash(title, text)
    }

    HideHelp(){
        SplashTextOff
    }

    ShowSplash(title, text){
        SplashTextOn, 1200, 600, %title% , %text%
    }

    GetCommandsList(){
        helpText := "Available Commands: `n"

        For index, subItem in this.SubItems
        {
            text := subItem.FormatItemText()
            helpText .= text . "`n"
        }

        return helpText
    }

    GetTitle(){
        return this.Description
    }

    FormatItemText(){
        return Format(" {1} -> {2}" , this.Description, this.Letter)
    }

    LaunchCommand(command){
        this.AssignRoot()
        this.BeforeActivation()
        for index, cmd in this.SubItems
        {
            letter:= cmd.Letter
            if(letter == command)   {
                cmd.ActivateItem()
            }
        }
    }

    ActivateItem() {
        this.AssignRoot()
        this.ShowCommandsAndLaunchSelected()
    }

    BeforeActivation(){
    }

    AssignRoot(){
        for index, items in this.SubItems
        {
            ; Log("[Item] This {1}, subItem: {2}, Root : {3}, Parent {4}, new Root: {5}", [this.Description, newItem.Description, this.Root.Description, newItem.Parent.Description, newItem.Root.Description])
            items.Root := this.Root
        }
    }


}
