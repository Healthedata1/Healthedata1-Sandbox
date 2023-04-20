### FOO

page variables

page.url = {{page.url}}

page.name = {{page.name}}

page.id = {{page.id}}

page.title = {{page.title}}

page.path = {{page.path}}


<ul>
{% for scope in site.data.scopes %}
  <li>
      {{ scope }}
  </li>
  <li>
      {{ scope.page_path }}
  </li>
  <li>
      {{ scope.add_scope }} ???
  </li>
    <li>
       for {{ scope.data }}
  </li>
      <li>
        scope example : 'patient/{{ scope.resource_type }}.rs'
  </li>
        <li>
       granular scope example : 'patient.{{ scope.resource_type }}.rs?category={{scope.category}}'
  </li>
{% endfor %}
</ul>
{% assign smart_scope = false %}
{% for scope in site.data.scopes %}
  {% if scope.page_path == page.path %}
  scope.page_path = page.path!!!
    {%capture smart_scope %}
- Servers providing access to {{ scope.data }} data **SHOULD** use version 2.0.0 of SMART App Launch support for:
  -  [resource level scopes] (for example, `patient/{{ scope.resource_type }}.rs`){% if scope.category_1 %}
  -  [granular scopes] (for example, `patient.{{scope.resource_type }}.rs?{{ scope.category_1 }}`{% if scope.category_2 %} and `patient.{{scope.resource_type }}.rs?{{ scope.category_2 }}`{% endif %}){% if scope.category_3 %} and `patient.{{scope.resource_type }}.rs?{{ scope.category_3 }}`{% endif %}){% endif %}.
    {% endcapture %}
    {% break %}
  {% endif %}
{% endfor %}

{{smart_scope}}

{% if smart_scope -%}{{smart_scope}}{% endif -%}


