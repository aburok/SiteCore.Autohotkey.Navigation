class SitecoreAdminItem extends SitecoreEditPageMenuItem {
    __New(letter, description, page){
        format := "{1}/sitecore/admin/" . page
        base.__New(letter, description, format)
    }
}

