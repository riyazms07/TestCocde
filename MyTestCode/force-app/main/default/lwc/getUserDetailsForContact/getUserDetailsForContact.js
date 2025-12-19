import { LightningElement , api, wire} from 'lwc';
/* Lightning Data Service API with default fuinction to get records without using an Apex method  */
import { getRecord } from 'lightning/uiRecordApi';
/* import  the Email field of the Contact object  */
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
 /* import Apex method used in this component */
import getUserRecordByEmail from '@salesforce/apex/GetUserDetails.getUserRecordByEmail';
 /* import custom labels to display UI messages */
import CONTACT_NO_EMAIL_MESSAGE from '@salesforce/label/c.ContactDoesntHaveEmailMessage';
import NO_USER_FOUND_MESSAGE   from '@salesforce/label/c.NoUserFoundMessage';
/* These are the fields of the Contact object to be retrieved using the wired function  */
const CONTACT_FIELDS = [EMAIL_FIELD];
export default class GetUserDetailsForContact extends LightningElement {
    /* Public property to hold the record Id of the Contact , automatically set by the Lightning framework from the record page */
    @api recordId;
    email;
    errorMesage;
    displayError = false;
    /* Variable to hold the User record returned by the Apex method */
    userRecord;
   /* Wired function to get contacts email, without using apex method  */
    @wire(getRecord,{recordId :'$recordId',fields: CONTACT_FIELDS })
    wireGetContactRecord({error,data}){
        if(data){
            this.email = data.fields.Email.value;
            /* If the Contact doesn't have an email, display a message and stop the process */
            if(!this.email){
                this.handleErrors(CONTACT_NO_EMAIL_MESSAGE);
                return;
            }
           /* If the Contact has an email, call the Apex method to get the User record  */
           this.getUserDetailsByEmail();
        }
        else if(error){
            this.handleErrors(error.body.message);
        }
    }
    /* Call Apex method to get User record details */
    getUserDetailsByEmail(){
        getUserRecordByEmail({contactEmail:this.email})
        .then(userData=>{
            /* If no User record exists for the email, display a message and stop the processs */
            if(!userData){
                this.handleErrors(NO_USER_FOUND_MESSAGE);
                return;
            }
            this.userRecord = userData;
        })
        .catch(error=>{
            this.handleErrors(error.body.message);
        })
    }
     /* Method to handles all errors , reusable function and avoid redundant code lines */
    handleErrors(message){
        this.errorMesage = message;
        this.displayError = true;
    }
    
}