import { LightningElement } from "lwc";

import { NavigationMixin } from "lightning/navigation";
const OPPORTUNITY_COLS = [
    {
        label: "User",
        type: "button",
        typeAttributes: { label: { fieldName: "User" }, name: "gotoOpportunity", variant: "base" }
    },
    {
        label: "User1",
        fieldName: "User1"
    },
    
];

export default class DatatableNavigationDemo extends NavigationMixin(LightningElement) {
    opportunityCols = OPPORTUNITY_COLS;

    // @wire(getOpportunities, {})
    // opportunities;

     handleRowAction(event) {
         if (event.target.label === "gotoOpportunity") {
    //         this[NavigationMixin.GenerateUrl]({
    //             type: "standard__recordPage",
    //             attributes: {
    //                 recordId: event.detail.row.Id,
    //                 actionName: "view"
    //             }
    //         }).then((url) => {
    //             window.open(url, "_blank");
    //         });
    //     }
    //     if (event.detail.action.name === "editOpportunity") {
    //         this[NavigationMixin.Navigate]({
    //             type: "standard__recordPage",
    //             attributes: {
    //                 recordId: event.detail.row.Id,
    //                 actionName: "edit"
    //             }
    //         });
    //     }
     }
    }
}