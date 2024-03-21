({
    handleClick : function(component, event, helper) {
        var searchText = component.get('v.searchText');
        //var action = component.get('c.searchForIds');
        //action.setParams({searchText: searchText});
        sessionStorage.setItem( 'searchText', searchText );
        console.log( 'searchText is', localStorage.getItem( 'searchText' ));
        
        var pageReference = {
            type: 'standard__webPage',
            attributes: {
                url: "/job-list"
            }
        };

        var navService = component.find("navService");
        navService.navigate(pageReference);
    }
})