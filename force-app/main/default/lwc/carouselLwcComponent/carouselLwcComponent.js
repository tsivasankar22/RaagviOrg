import { LightningElement } from 'lwc';
import Images1 from '@salesforce/resourceUrl/CarouselImages';
import Images2 from '@salesforce/resourceUrl/CarouselImages1';
import Images3 from '@salesforce/resourceUrl/CarouselImages2';

export default class CarouselLwcComponent extends LightningElement {
    image1 = Images1;
    image2 = Images2;
    image3 = Images3;
}