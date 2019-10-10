import { LightningElement, api, track } from "lwc";
import casesToClone from "@salesforce/apex/CloneMultipleCases.casesToClone";

export default class CloneCasesControl extends LightningElement {
  @api recordId;

  @track clonedCaseIds;
  @track displayClonedCases = false;
  @track numberOfClones;
  @track error;

  didPressCloneButton(event) {
    this.doCloneCases();
  }

  handleCloneCountChange(event) {
    this.numberOfClones = event.target.value;
  }

  doCloneCases() {
    casesToClone({
      numberOfCases: this.numberOfClones,
      caseId: this.recordId
    })
      .then(result => {
        this.clonedCaseIds = result;
        this.displayClonedCases = true;
        this.error = undefined;
      })
      .catch(error => {
        this.error = error;
        this.clonedCaseIds = undefined;
      });
  }
}
