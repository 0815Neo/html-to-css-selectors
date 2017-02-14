# html-to-less-selectors
Tool to convert you html structure to less selectors with ids and class names.

## Demo
You can find a demonstration on jsfiddle.net (http://jsfiddle.net/j0r7b6qg/4/). If
you use an element with an id and a class you get invalid less code, so you have
to choose which selector you wanna use.

## Todo
### Find duplicates
If you have a list for example:
```
<li>{% trans %}global.nw.heading{% endtrans %}
    <ul>
        <li><a href="#">{% trans %}global.nw.a.heading{% endtrans %}</a></li>
        <li><a href="#">{% trans %}global.nw.b.heading{% endtrans %}</a></li>
        <li><a href="#">{% trans %}global.nw.3.heading{% endtrans %}</a></li>
    </ul>
</li>
<li>{% trans %}global.pcs.heading{% endtrans %}
    <ul>
        <li><a href="#">Placeholder</a></li>
        <li><a href="#">Placeholder</a></li>
    </ul>
</li>
<li>{% trans %}global.hlp.heading{% endtrans %}
    <ul>
        <li><a href="#">Placeholder</a></li>
        <li><a href="#">Placeholder</a></li>
    </ul>
</li>
```

You will gather duplicates in your less code as seen below:
```
body {
    li {
        ul {
            li {
                a {}
            }
            li {
                a {}
            }
            li {
                a {}
            }
        }
    }
    li {
        ul {
            li {
                a {}
            }
            li {
                a {}
            }
        }
    }
    li {
        ul {
            li {
                a {}
            }
            li {
                a {}
            }
        }
    }
}
```
