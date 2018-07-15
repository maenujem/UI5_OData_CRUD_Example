sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/m/MessageBox"
], function(Controller, MessageBox) {
	"use strict";

	return Controller.extend("test_MasterDetailTable.controller.Detail", {

		/**
		 * Called when a controller is instantiated and its View controls (if available) are already created.
		 * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
		 * @memberOf test_MasterDetailTable.view.Detail
		 */
		onInit: function() {

			this.getView().setModel(this.getOwnerComponent().getModel("employees"));
			
			// prepare access to router
			var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
			oRouter.getRoute("detail").attachPatternMatched(this._onObjectMatched, this);
		},

		/**
		 * Similar to onAfterRendering, but this hook is invoked before the controller's View is re-rendered
		 * (NOT before the first rendering! onInit() is used for that one!).
		 * @memberOf test_MasterDetailTable.view.Detail
		 */
		//	onBeforeRendering: function() {
		//
		//	},

		/**
		 * Called when the View has been rendered (so its HTML is part of the document). Post-rendering manipulations of the HTML could be done here.
		 * This hook is the same one that SAPUI5 controls get after being rendered.
		 * @memberOf test_MasterDetailTable.view.Detail
		 */
		//	onAfterRendering: function() {
		//
		//	},

		/**
		 * Called when the Controller is destroyed. Use this one to free resources and finalize activities.
		 * @memberOf test_MasterDetailTable.view.Detail
		 */
		//	onExit: function() {
		//
		//	}
		
		/**
		 * Read from URL parameter which entry to display and bind it to form
		 */
		_onObjectMatched: function (oEvent) {
			var aDetailId, selectedItemPath, detailForm;
			aDetailId = oEvent.getParameter("arguments").detailId.split('-'); // extract keys for entry from arguments <Carrier>-<EmployeeId> in URL
			selectedItemPath = "/ZTT_EMPLOYEE_MSCSet(Carrier='" + aDetailId[0] + "',IdEmployee='" + aDetailId[1] + "')";
			detailForm = this.getView().byId("detailForm");
			detailForm.bindElement({path: selectedItemPath});
		},
		
		onNavToMaster: function (oEvent){
			this.getOwnerComponent().getRouter().navTo("master");
		},
		
		onEmployeeCreate: function() {
			var path ="/ZTT_EMPLOYEE_MSCSet";
			var boundItem = this.getView().getModel().getProperty(this.getView().byId("detailForm").getElementBinding().getPath());
			var msg = this.getView().getModel("i18n").getResourceBundle().getText("employeeCreated", boundItem.IdEmployee);
			this.getView().getModel().create(path, boundItem, {
				success: function(){
					MessageBox.success(msg);
				},
				error: function(oError){
					MessageBox.error(oError.responseText);
				}
			});
		},
		
		onEmployeeUpdate: function() {
			var path = this.getView().byId("detailForm").getElementBinding().getPath();
			var boundItem = this.getView().getModel().getProperty(path);
			// var lastname = boundItem.Lastname; // nok: getProperty()  getValue() data() oEvent.getSource().data("IdEmployee")
			var msg = this.getView().getModel("i18n").getResourceBundle().getText("employeeUpdated", boundItem.IdEmployee);
			this.getView().getModel().update(path, boundItem, {
				success: function(){
					MessageBox.success(msg); // update does not return anything
				},
				error: function(oError){
					MessageBox.error(oError.responseText);
				}
			});
		},
		
		onEmployeeDelete: function() {
			var path = this.getView().byId("detailForm").getElementBinding().getPath();
			var boundItem = this.getView().getModel().getProperty(path);
			var msg = this.getView().getModel("i18n").getResourceBundle().getText("employeeDeleted", boundItem.IdEmployee);
			this.getView().getModel().remove(path, {
				success: function(){
					MessageBox.success(msg);
				},
				error: function(oError){
					MessageBox.error(oError.responseText);
				}
			});
		}

	});
});