### Creat Pretty List with Liquid

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

svg file:

{% include my_plantuml.svg %}
