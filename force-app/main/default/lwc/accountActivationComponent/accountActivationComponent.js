import { LightningElement, api } from 'lwc';
import activateAccount from '@salesforce/apex/AccountActivationController.activateAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountActivationComponent extends LightningElement {
    @api recordId;
    activationSummary = '';

    handleSummaryChange(event) {
        this.activationSummary = event.target.value;
    }

    handleActivate() {
        if (!this.activationSummary) {
            this.showToast('Error', 'Please provide Account Activation Summary.', 'error');
            return;
        }

        activateAccount({ recordId: this.recordId, activationSummary: this.activationSummary })
            .then(() => {
                this.showToast('Success', 'Account activated successfully.', 'success');
                // Optionally, refresh the view
                // return refreshApex(this.wiredData);
            })
            .catch(error => {
                console.error('Error activating account:', error);
                this.showToast('Error', 'Error activating account.', 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}