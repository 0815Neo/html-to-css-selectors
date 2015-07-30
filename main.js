var DOMtoCSS = {
    output: "",
    
    elements_struct: function() {
        this.tag = "";
        this.elements = new Array();
        this.classes = new Array();
        this.id = "";
    },
    
    outputSelector: function(content) {
        DOMtoCSS.output += content + " {\n    \n}\n";
    },
    
    getElements: function(element, elements, space = 0) {
        // If last element was reached exit recursion
        if($(element).length == 0) {
            return;
        }
        
        // Get classes
        var classes_string = $(element).attr('class');
        if (classes_string != undefined) {
            elements.classes = classes_string.split(' ');
        } else {
            elements.classes = new Array();
        }        
        
        // Get tagname and id
        elements.id = $(element).attr('id');    
        elements.tag = $(element).prop("tagName");
        
        // Call recursion
        $(element).children().each(function() {
            var new_elements = new DOMtoCSS.elements_struct();
            
            elements.elements.push(DOMtoCSS.getElements(this, new_elements, space+1));
        });
        
        return elements;
    },
    
    
    // Output css
    generateCSS: function(element, prefix = "") {
        // Added previous selectors to selector
        var text = prefix;
        
        // Add tagname
        text += element.tag.toLowerCase();
        
        // Add id if set
        if (element.id != undefined && element.id.length > 0) {
            text += "#" + element.id;
        }
        
        // Outut with id and tagname
        console.log(text);
        DOMtoCSS.outputSelector(text);
        
        // Added classes
        if (element.classes.length > 0) {
            for (var i = 1; i <= element.classes.length; i++) {
                text += "." + element.classes.slice(i-1,i).join();
                // Output for every class
                console.log(text);
                DOMtoCSS.outputSelector(text);
            }
        }
        
        // Add operator
        prefix = text + " > ";
        
        // Call recursion
        $.each(element.elements, function(index, value) {
            text += DOMtoCSS.generateCSS(value, prefix);
        });
    }
};

// Initalize data
var body_elements = new DOMtoCSS.elements_struct();

// Run
DOMtoCSS.getElements($('SELECTOR'), body_elements);
DOMtoCSS.generateCSS(body_elements);
$('body').html('<pre>' + DOMtoCSS.output + '</pre>');
