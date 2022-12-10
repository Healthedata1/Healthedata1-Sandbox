
### Escape curly braces

{% raw %}{{% endraw %}{{site.data.foo['fun/time']['description']}}}

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

----

{% raw %}
~~~liquid
{%- assign black_list = "Extension,Provenance,Medication,Organization,Practitioner,PractitionerRole,Location" | split:"," -%}
{% assign r_list = "" %}
{%- for sd_hash in site.data.structuredefinitions -%}
  {%- assign sd = sd_hash[1] -%}
  {%- unless black_list contains sd.type -%}
       {% capture r_list %}{{ r_list | append: sd.type | append: "," }}{% endcapture %}
  {%- endunless -%}
{%- endfor -%}
{% assign ur_list = r_list | split: "," | uniq | sort %}
<ul>
{% for r in  ur_list %}
    <li>{{r}}</li>
{% endfor %}
</ul>
~~~
{% endraw %}


{%- assign black_list = "Extension,Provenance,Medication,Organization,Practitioner,PractitionerRole,Location" | split:"," -%}
{% assign r_list = "" %}
{%- for sd_hash in site.data.structuredefinitions -%}
  {%- assign sd = sd_hash[1] -%}
  {%- unless black_list contains sd.type -%}
       {% capture r_list %}{{ r_list | append: sd.type | append: "," }}{% endcapture %}
  {%- endunless -%}
{%- endfor -%}
{% assign ur_list = r_list | split: "," | uniq | sort %}
<ul id="prov-white-list">
{% for r in  ur_list %}
    <li>{{r}}</li>
{% endfor %}
</ul>
---

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
manually added linenow
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
linenos with liquid/Jekyll

{% highlight yaml linenos %}
  differential:
    element:
      - id: Observation
       path: Observation
      - id: 'Observation.meta'
        path: 'Observation.meta'
        min: 1
        mustSupport: true
{% endhighlight %}


using classses

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


Includes the specified lines from another file.  Typically this include is used for fragments of FHIR resources and therefore is wrapped in a code block. It also optionally displays the line number of the included fragment.  The line number is the line number in the source file, not the line number in the output file.

this helper lives in the input/images folder not the include file folder
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

  - filename: path to file in temp/pages  (use  _include/file.ext for includes files ) NOTE MARKDOWN IS RENDERED IN THE INCLUDED FILE :-(
  - start: integer (only 1) or common separated string (> 1) of first line numbers to include, starting at 1
  - count: integer (only 1) or common separated string (> 1) of number of lines to include
  - linenumber: optional boolean to display line number (default is false)

The start and count item are aggregated into a (start, count) tuple and therefore need to be the same size.  If there are more than one start and count items, ellipses ("...") will be inserted between the line fragments. 
The helper file checks if the line overlap.  If they do it will print a warning message instead of your intended output.
  
#### Examples:

**1. single fragment:**

\~~~

{% raw %}{% include_relative includelines filename='patient-deceased-example.json' start=1 count=15 linenumber=true rel=true %}{% endraw %}

\~~~

~~~json
{% include_relative includelines filename='patient-deceased-example.json' start=1 count=15 linenumber=true rel=true %}
~~~

 **2. multiple fragments separated by "...":**
   
\~~~

{% raw %}{% include_relative includelines filename='patient-deceased-example.json' start = "10,20,30" count="5,5,5" %}{% endraw %}

\~~~

~~~
{% include_relative includelines filename='patient-deceased-example.json' start = "10,20,30" count="5,5,5" rel=true linenumber=true %}
~~~

**3. The helper file checks if the line overlap.  If they do it will print a warning message instead of your intended output.
The following will result in a warning message because the start line (15) is less than the previous plus the number of lines (20)**

\~~~

{% raw %}{% include_relative includelines filename='patient-deceased-example.json' start = "10,15,30" count="10,5,5" %}{% endraw %}

\~~~


~~~
{% include_relative includelines filename='patient-deceased-example.json' start = "10,15,30" count="10,5,5" rel=true %}
~~~


---

### Example button

#### Mandatory Operation:

1. **SHALL** support fetching documents using the $docref operation.

    This [$docref operation] is used to request a server *generate* a document based on the specified parameters. This operation is invoked on a FHIR Server's DocumentReference endpoint (e.g., `[base]/DocumentReference/$docref`) and operates across all DocumentReference instances returning a Bundle of DocumentReference resources. See the [$docref operation] definition for detailed documentation.

   - The operation can be invoked using the GET Syntax if the complex type parameter is omitted:

      `GET [base]/DocumentReference/$docref?{parameters}`

   - Otherwise the POST transaction with used as follows:

      `POST [base]/DocumentReference/$docref`

       The body of the POST contains the [Parameters] resource with the [$docref operation] input parameters.

   **Example 1: Request the latest CCD**

          {% include examplebutton_default.html example="docref-example1" b_title = "Click Here To See Example" %}

   **Example 2: Request Procedure Notes and Discharge Summaries for 2019**

         {% include examplebutton.html example="docref-example2" b_title = "Click Here To See Example" %}

</div><!-- new-content -->