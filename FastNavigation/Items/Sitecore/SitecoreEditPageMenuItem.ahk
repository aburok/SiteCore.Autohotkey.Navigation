class SitecoreEditPageMenuItem extends WebsiteMenuItem {
    __New(letter, description, url){
        base.__New(letter, description, url)
    }

    GetDomain(){
        Log("GetDomain {1}", this.Root.Environment.Master.Url)
        return this.Root.Environment.Master.Url
    }

    GetFormatArgs(){
        formatArgs := [this.GetDomain()]
        Return formatArgs
    }
}
