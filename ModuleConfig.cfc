component {

	this.name = "cbopenai";
	this.version = "1.0.0";
	this.author = "";
	this.webUrl = "https://github.com/coldbox-modules/cbopenai";
	this.dependencies = [];

	this.entryPoint = "cbopenai";

	this.layoutParentLookup = false;
	this.viewParentLookup = false;
	this.cfmapping = "cbopenai";
	this.modelNamespace = "cbopenai";
	this.applicationHelper = [ "helpers/helpers.cfm" ];

	function configure(){
		settings = {

		};

		interceptorSettings = {
			customInterceptionPoints : []
		};

		interceptors = [
		];
	}

}
