DOMtoCSS =
    output: ""

    elements_struct: ->
        this.tag = ""
        this.elements = new Array()
        this.classes = new Array()
        this.id = ""


    getTabs: (count) ->
        Array(count+1).join('    ').toString()


    outputSelector: (content) ->
        DOMtoCSS.output += content + " {\n    \n}\n"


    outputLESSSelector: (content, already_closed = false) ->
        if !already_closed
	        DOMtoCSS.output += content + " {\n"
        else
            DOMtoCSS.output += content + "{}\n"


    outputLESSTail: (tabs) ->
        DOMtoCSS.output += DOMtoCSS.getTabs(tabs) + "}\n"

    getElements: (element, elements, space = 0) ->
        # If last element was reached exit recursion
        if $(element).length == 0
            return

        # Get classes
        classes_string = $(element).attr('class')
        if classes_string != undefined
            elements.classes = classes_string.split(' ')
        else
            elements.classes = new Array()

        # Get tagname and id
        elements.id = $(element).attr('id')
        elements.tag = $(element).prop("tagName")

        # Call recursion
        $(element).children().each( ->
            new_elements = new DOMtoCSS.elements_struct();

            elements.elements.push(DOMtoCSS.getElements(this, new_elements, space+1));
        )

        return elements;



    # Output css
    generateCSS: (element, prefix = "") ->
        # Added previous selectors to selector
        text = prefix

        # Add tagname
        text += element.tag.toLowerCase()

        # Add id if set
        if element.id != undefined && element.id.length > 0
            text += "#" + element.id

        # Outut with id and tagname
        console.log(text)
        DOMtoCSS.outputSelector(text)

        # Added classes
        if element.classes.length > 0
            for _class, i in element.classes
                text += "." + element.classes.slice(i-1,i).join()
                # Output for every class
                console.log(text)
                DOMtoCSS.outputSelector(text)

        # Add operator
        prefix = text + " > ";

        # Call recursion
        $.each(element.elements, (index, value) ->
            text += DOMtoCSS.generateCSS(value, prefix)
        )

    # Output less
    generateLESS: (element, tabs = 0) ->
        # Added previous selectors to selector
        tabs_text = DOMtoCSS.getTabs(tabs)
        text = ""

        # Add tagname
        text += element.tag.toLowerCase()

        # Add id if set
        if element.id != undefined && element.id.length > 0
            text += "#" + element.id

        # Outut with id and tagname
        console.log(tabs_text + text)
        DOMtoCSS.outputLESSSelector(tabs_text + text, (element.elements.length < 1 || element.classes.length > 0))

        # Added classes
        if element.classes.length > 0
            for _class, i in element.classes
                text += "." + element.classes.slice(i,i+1).join()
                # Output for every class
                console.log(tabs_text + text)
                DOMtoCSS.outputLESSSelector(tabs_text + text, (i < element.classes.length && element.elements.length < 1))


       	if element.elements.length > 0
            $.each(element.elements, (index, value) ->
                text += DOMtoCSS.generateLESS(value, tabs + 1)
            )

            DOMtoCSS.outputLESSTail(tabs)

# Initalize data
body_elements = new DOMtoCSS.elements_struct()

# Run
DOMtoCSS.getElements($('div.wrapper'), body_elements)
console.log(body_elements);
DOMtoCSS.generateLESS(body_elements)
$('body').html('<pre>' + DOMtoCSS.output + '</pre>')
