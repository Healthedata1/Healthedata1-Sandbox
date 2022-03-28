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
