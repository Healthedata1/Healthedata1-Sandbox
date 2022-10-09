{% raw %}{{ site.data.foo['fun/time']['description']}} {% endraw %}: {{ site.data.foo['fun/time']['description']}}

### Create Pretty List with Liquid

<!-- if site.users = "Tobi", "Laura", "Tetsuro", "Adam" -->

### My new stuff


{% for stuff in site.data.new_stuff %}
  {%- for new in site.data.new_stuff -%}
     {%- if stuff == new -%}
     {%- assign new_stuff = true -%}
     {%- break -%}
     {%- endif -%}
  {%- endfor -%}
{%- if new_stuff -%}  
- <span class="bg-success" markdown="1">"{{stuff}}"</span><!-- new-content -->
{%- else -%}
- {{ stuff }}
{% endif %}
{% endfor %}

---

{% raw %}
~~~liquid
<ul>
{%- assign black_list = "Extension,Provenance,Medication,Organization,Practitioner,PractitionerRole,Location" | split:"," -%}
{%- for sd_hash in site.data.structuredefinitions -%}
  {%- assign sd = sd_hash[1] -%}
  {%- unless black_list contains sd.type -%}
    {%- for r_hash in site.data.resources -%}
      {%- assign r = r_hash[1] -%}
      {%- if r.name == sd.name -%}
         <li>{{r.title}}</li>
      {%- endif -%}
    {%- endfor -%}
  {%- endunless -%}
{%- endfor -%}
</ul>
~~~
{% endraw %}

<ul>
{%- assign black_list = "Extension,Provenance,Medication,Organization,Practitioner,PractitionerRole,Location" | split:"," -%}
{%- for sd_hash in site.data.structuredefinitions -%}
  {%- assign sd = sd_hash[1] -%}
  {%- unless black_list contains sd.type -%}
    {%- for r_hash in site.data.resources -%}
      {%- assign r = r_hash[1] -%}
      {%- if r.name == sd.name -%}
         <li>{{r.title}}</li>
      {%- endif -%}
    {%- endfor -%}
  {%- endunless -%}
{%- endfor -%}
</ul>


{% raw %}
~~~liquid
{%- for sd_hash in site.data.structuredefinitions -%}
  {%- assign sd1= sd_hash[1] -%}
  {% assign types =  types | append: "," | append: sd1.type %}
{% endfor %}
{% assign my_types = types | split: "," %}
{% assign my_types = my_types | sort | uniq %}
{% for i in my_types %}
  <strong>{{ i }}</strong>
  <ul>
    {%- for sd_hash in site.data.structuredefinitions -%}
      {%- assign sd1 = sd_hash[1] -%}
      {%- if sd1.type == i %}
        {%- assign parent = false -%}
        {%- assign child = false -%}
        {%- for sd_hash2 in site.data.structuredefinitions -%}
          {%- assign sd2 = sd_hash2[1] -%}
          {% if sd1.basename == sd2.name %}
            {%- assign child = true -%}
            {% break %}
          {% elsif sd1.name == sd2.basename%}
             {%- assign parent = true -%}
             {% break %}
          {% endif %}
        {% endfor %}
          {%- unless parent or child -%}
            <li><a href="{{sd1.path}}">{{sd1.title}}</a></li>
          {%- endunless -%}
          {%- if parent -%}
            <li><a href="{{sd1.path}}">{{sd1.title}}(Parent)</a>
                <ul>
                {%- for sd_hash3 in site.data.structuredefinitions -%}
                  {%- assign sd3 = sd_hash3[1] -%}
                  {% if sd1.name == sd3.basename %}
                    <li><a href="{{sd3.path}}">{{sd3.title}}(child)</a></li>
                  {% endif %}
                {% endfor %}
                </ul>
            </li>
          {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
  </ul>
{% endfor %}

~~~~
{% endraw %}

{%- for sd_hash in site.data.structuredefinitions -%}
  {%- assign sd1= sd_hash[1] -%}
  {% assign types =  types | append: "," | append: sd1.type %}
{% endfor %}
{% assign my_types = types | split: "," %}
{% assign my_types = my_types | sort | uniq %}
{% for i in my_types %}
  <strong>{{ i }}</strong>
  <ul>
    {%- for sd_hash in site.data.structuredefinitions -%}
      {%- assign sd1 = sd_hash[1] -%}
      {%- if sd1.type == i %}
        {%- assign parent = false -%}
        {%- assign child = false -%}
        {%- for sd_hash2 in site.data.structuredefinitions -%}
          {%- assign sd2 = sd_hash2[1] -%}
          {% if sd1.basename == sd2.name %}
            {%- assign child = true -%}
            {% break %}
          {% elsif sd1.name == sd2.basename%}
             {%- assign parent = true -%}
             {% break %}
          {% endif %}
        {% endfor %}
          {%- unless parent or child -%}
            <li><a href="{{sd1.path}}">{{sd1.title}}</a></li>
          {%- endunless -%}
          {%- if parent -%}
            <li><a href="{{sd1.path}}">{{sd1.title}}(Parent)</a>
                <ul>
                {%- for sd_hash3 in site.data.structuredefinitions -%}
                  {%- assign sd3 = sd_hash3[1] -%}
                  {% if sd1.name == sd3.basename %}
                    <li><a href="{{sd3.path}}">{{sd3.title}}(child)</a></li>
                  {% endif %}
                {% endfor %}
                </ul>
            </li>
          {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
  </ul>
{% endfor %}


### List highlighting

- {:.new-content}floor
- bar
- {:.new-content}baz
  - 1
  - 2


### My Awesome Table

from this...

~~~
### My Awesome Table

tadaa...

| **Term** | **Definition** |
| --- | --- |
| **Batch File Format** | The file formats used to load data into PLR or receive distributions from PLR in bulk, on a delayed basis. <br /><br />See also Batch XML Format and Batch CSV Format. |
| **Category** | A "super-role", a category of related Provider Role Types. <br /><br />For example, the category "Nurse" might contain many Provider Role Types such as "LPN", RN" and so on; the category "Doctors" might contain all Provider role types assigned to doctors, and so on. |
{: .grid}
~~~

to this...

tadaa...

| **Term** | **Definition** |
| --- | --- |
| **Batch File Format** | The file formats used to load data into PLR or receive distributions from PLR in bulk, on a delayed basis. <br /><br />See also Batch XML Format and Batch CSV Format. |
| **Category** | A "super-role", a category of related Provider Role Types. <br /><br />For example, the category "Nurse" might contain many Provider Role Types such as "LPN", RN" and so on; the category "Doctors" might contain all Provider role types assigned to doctors, and so on. |
{: .grid}


   test code block
   {: style="color: red"}

### svg file

{% include my_plantuml.svg %}



### Code Blocks

```yaml
1:  differential:
2:    element:
3:      - id: Observation
4:        path: Observation
5:      - id: 'Observation.meta'
6:        path: 'Observation.meta'
7:        min: 1
8:        mustSupport: true
```


{% highlight yaml %}
1:  differential:
2:    element:
3:      - id: Observation
4:        path: Observation
5:      - id: 'Observation.meta'
6:        path: 'Observation.meta'
7:        min: 1
8:        mustSupport: true
{% endhighlight %}


<pre class="line-numbers">
<code class="language-yaml">
1:  differential:
2:    element:
3:      - id: Observation
4:        path: Observation
5:      - id: 'Observation.meta'
6:        path: 'Observation.meta'
7:        min: 1
8:        mustSupport: true
</code>
</pre>

### Bootstrap Panels


### Stacked Panels

{% include uscdi-uscore-map.html %}

### Sorting using Liquid

original collection:

{{ site.data.structuredefinitions }}

sorted collection:
{% comment %}{% raw %}<!--
 {% assign sds = site.data.structuredefinitions  | sort: "title"%}  # does not work :-(
 {% assign sorted =  sds | sort: "title" %}
<ul>
  {% for sd in sorted %}
    <li>
    {{sd[0]}}
      


    </li>
    <li>
    {{sd[1]}}
      


    </li>
    <li>
    {sd[1].title}}
      


    </li>

  {% endfor %}
-->{% endraw %}{% endcomment %}

### include lines using helper file


Includes the specified lines from another file. Typically this include is used for fragments of FHIR resources and therefore is wrapped in a code block.

The helper file is place in the `input/images` folder not the 'input/include` file folder
~~~
├── examples
│   ├── patient-deceased-example.json
│   └── patient-example.json
├── fsh
│   ├── fsh
│   ├── my-extensions.fsh
│   └── my-profiles.fsh
├── ignoreWarnings.txt
├── images
│   ├── cat.jpg
│   ├── includelines  <<<< HERE
├── includes  <<<< NOT HERE
│   ├── DAR-exception.md
│ 
~~~

Usage:
  {% raw %}{% include_relative includelines filename=PATH start=INT|STR count=INT|STR %}{% endraw %}

  - filename: path to file in temp/pages  (not under _includes )
  - start: integer (only 1) or common separated string (> 1) of first line numbers to include, starting at 1
  - count: integer (only 1) or common separated string (> 1) of number of lines to include

The start and count item are aggregated into a (start, count) tuple and therefore need to be the same size.  If there are more than one start and count items, ellipses ("...") will be inserted between the line fragments. 
The helper file checks if the line overlap.  If they do it will print a warning message instead of your intended output.
  
#### Examples:

**1. single fragment:**

\~~~

{% raw %}{% include_relative includelines filename='patient-deceased-example.json' start=10 count=5 %}{% endraw %}

\~~~

~~~
{% include_relative includelines filename='patient-deceased-example.json' start=10 count=5 %}
~~~

 **2. multiple fragments separated by "...":**
   
\~~~

{% raw %}{% include_relative includelines filename='patient-deceased-example.json' start = "10,20,30" count="5,5,5" %}{% endraw %}

\~~~

~~~
{% include_relative includelines filename='patient-deceased-example.json' start = "10,20,30" count="5,5,5" %}
~~~

**3. The helper file checks if the line overlap.  If they do it will print a warning message instead of your intended output.
The following will result in a warning message because the start line (15) is less than the previous plus the number of lines (20)**

\~~~

{% raw %}{% include_relative includelines filename='patient-deceased-example.json' start = "10,15,30" count="10,5,5" %}{% endraw %}

\~~~


~~~
{% include_relative includelines filename='patient-deceased-example.json' start = "10,15,30" count="10,5,5" %}
~~~

---