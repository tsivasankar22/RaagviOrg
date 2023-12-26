import { LightningElement, track } from 'lwc';
import retriveNews from '@salesforce/apex/CalloutsUsiingLWC.retriveNews';

export default class CalloutsUsingLWC extends LightningElement {
    
    @track selectedNews = {};
    @track isModalOpen = false;
    @track result = [];

    // Dynamically sets the CSS classes for the modal
    get modalClass() {
        return `slds-modal ${this.isModalOpen ? 'slds-fade-in-open' : ''}`;
    }

    // Dynamically sets the CSS classes for the modal backdrop
    get modalBackdropClass() {
        return this.isModalOpen ? 'slds-backdrop slds-backdrop_open' : 'slds-backdrop';
    }

    connectedCallback() {
        // Fetches data when the component is connected
        this.fetchNews();
    }

    // Invokes the Apex method to retrieve news data
    fetchNews() {
        retriveNews()
            .then(response => {
                console.log(response);
                this.formatNewsData(response.articles);
            })
            .catch(error => {
                console.error(error);
            });
    }
    // Formats the raw news data for display
    formatNewsData(res) {
        this.result = res.map((item, index) => {
            //here `new_${index + 1} it will print new_index 1 and 2 3 4 like that
            let id = `new_${index + 1}`;
            // here converting date format to string type
            let date = new Date(item.publishedAt).toDateString();
            let name = item.source.name;
            //spread operator it will retirn all items ids ,name and date 
            return { ...item, id: id, name: name, date: date };
        });
    }

    // Displays the selected  item in the modal
    showModal(event) {
        let id = event.target.dataset.item;
        this.result.forEach(item => {
            if (item.id === id) {
                this.selectedNews = { ...item };
            }
        });
        this.isModalOpen = true;
    }

    // Closes the modal
    closeModal() {
        this.isModalOpen = false;
    }
}
