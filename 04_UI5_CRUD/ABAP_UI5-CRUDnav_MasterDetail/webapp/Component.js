sap.ui.define([
	"sap/ui/core/UIComponent",
	"sap/ui/Device",
	"sap/ui/model/odata/v2/ODataModel",
	"test_MasterDetailTable/model/models"
], function(UIComponent, Device, ODataModel, models) {
	"use strict";

	return UIComponent.extend("test_MasterDetailTable.Component", {

		metadata: {
			manifest: "json"
		},

		/**
		 * The component is initialized by UI5 automatically during the startup of the app and calls the init method once.
		 * @public
		 * @override
		 */
		init: function() {
			// call the base component's init function
			UIComponent.prototype.init.apply(this, arguments);

		        // create the views based on the url/hash
		        this.getRouter().initialize();
            
			// set the device model
			this.setModel(models.createDeviceModel(), "device");
			
			// set the odata model for emoloyees
			// var sUrl = "/sap/opu/odata/sap/ZOD_EMPLOYEE_MSC_SRV/";
			// var oModel = new ODataModel(sUrl, {
			// 	useBatch: false,
			// 	defaultBindingMode: "TwoWay"
			// });
			//
			// this.setModel(oModel, "employees");
			// var oModel = this.getModel("employees");
			// oModel.setDefaultBindingMode(sap.ui.model.BindingMode.TwoWay);
			// oModel.setUseBatch(false);
			
		}
	});
});
