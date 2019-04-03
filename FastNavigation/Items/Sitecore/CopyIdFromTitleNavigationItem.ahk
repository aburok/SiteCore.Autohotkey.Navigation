class CopyIdFromTitleNavigationItem extends NavigationItem{
    __New(letter, description){
        base.__New(letter, description)
        this.titleParse := new WindowTitleParser()
    }

    ActivateItem(){
        infoPattern := this.Root.Config.Common.Patterns.Info
        item := this.titleParse.GetInfo(infoPattern)
        this.Root.Item := item

        Log("Parse ItemID : {1} Template: {2} Path: [{3}], Media [{4}] ", [item.itemId, item.templateId, item.Path, item.MediaId])

        base.ActivateItem()
    }
}

