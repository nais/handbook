# NAIS documentation guidelines

When writing [the documentation](https://github.com/nais/doc) we serve at [doc.nais.io](https://doc.nais.io) / `doc.<tenant>.cloud.nais.io`, we want to make sure that the content we provide helps our users to understand and use the platform we're making.

Some key points to keep in mind when writing the docs are:

- [Following the diataxis theory](#diataxis-httpsdiataxisfr)
- Less is more: Keep it short and to the point. This makes it easier to sustain high quality over time.
- We are writing docs for the _users_ of our platform. No one else. We should be empathetic to their needs and understanding of the platform, and be mindful of adding details that are not relevant in the current documentation context
- [Consistency](#conventions) in style and tone
- NAIS [Quality](https://diataxis.fr/quality/)

## Structure

We structure our content primarily around what services NAIS provide, with some [honest exceptions](#honest-exceptions).

Under each service, or category of services, we use Diataxis with the following convention:

The main page for a service is an _Explanation_ of the service. It should give a high-level overview of what the service is, why you would use it, and how it fits into the NAIS ecosystem.

Example structure:

```text
some-service/
├─ README.md # <- explanation
├─ how-to/
│  ├─ verb.md
├─ reference/
│  ├─ spec.md
├─ .pages
```

???+ note "Collapsed reference structure"

    If the service contains a single reference page, name the page `README.md`. This will collapse the directory structure in the navigation menu.


### Honest exceptions

- Top-level explanations
- Top-level tutorials
- Operate: Here we describe the tools and services that are used and required to operate the platform
- Tags overview
- Legal stuff

### .pages file

The `.pages` file is used to define overrides and customizations to the titles and order of the pages in the navigation menu. This is a feature of the [Awesome Pages plugin](https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin/) for MkDocs.

A conventional `.pages` file looks like this:

```text title=".pages"
title: My overridden title
nav:
- README.md
- 💡 Explanations: explanations
- 🎯 How-To: how-to
- 📚 Reference: reference
- application
- job
- ...
```

## Conventions

### Documentation structure

The file tree represents the structure of the navigation menu.
The H1 (#) will be the title of the page and the title in the navigation menu

To override the placement in the navigation menu, we use the [Awesome Pages plugin](https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin/) for MkDocs.

### Placeholder variables

Where the reader is expected to change the content, we use placeholder variables.
These variables are written in uppercase, with words separated by hyphens, surrounded by <>. For example: `<MY-APP>`.

### Tenant variables

We template the tenant name in the documentation using `<<tenant()>>`
When the documentation is built, this will be replaced with the relevant tenant name.

For even more convenience, we have a `<<tenant_url("service")>>` function that will replace the `service` with the relevant URL for the service and create a full tenant URL to the service. An optional second parameter can be used to specify the path to the service eg. `<<tenant_url("grafana", "explore")>>`

### Tenant-specific content

Some sections are specific for a given tenant:

```markdown title="page.md"
{%- if tenant() == "nav" %}
Tenant-specific content
{%- endif %}
```

...or for multiple tenants:

```markdown title="page.md"
{%- if tenant() in ("nav", "dev-nais") %}
Tenant-specific content
{%- endif %}
```

### Tenant-specific pages

If an entire page is specific to a tenant, specify the `conditional` field in the markdown front matter:

```markdown title="page.md"
---
conditional: [tenant, <tenant-name>]
---

# Title

...
```

- `tenant` marks the page as tenant-specific.
- `<tenant-name>` specifies which tenant that the page should be shown for.

### Code blocks

When using code blocks, set the correct language for syntax highlighting. Define a title and highlight lines if needed.

````markdown title="page.md"

```yaml title="describe content / filename" hl_lines="6-8 11"
apiVersion: nais.io/v1alpha1
kind: Application
...
```
````

### Alternate paths

When the user is given a choice, we want to show both paths in the documentation. For example programming language, OS or different methods

```markdown title="page.md"
=== "Linux"

  linux specific stuff

=== "macOS"

  macOS specific stuff

```

!!! note "Indentation and blank lines"

    Ensure you have tab indentation on the content block, as well as a blank line before and after.

### Links

We want to make sure that the links are consistent and easy to understand. We use the following structure for links:


| Type of Link  | Icon                        | Link                                                       |
|---------------|-----------------------------|------------------------------------------------------------|
| Explanation   | :bulb:                      | `[:bulb: Learn more about ...](../)`                       |
| How-to guide  | :dart:                      | `[:dart: Learn how to ...](../)`                           |
| Reference     | :books:                     | `[:books: Reference for ](../)`                            |
| Tutorial      | :rocket:                    | `[:rocket: Tutorial for ...](../)`                         |
| External link | :octicons-link-external-24: | `[:octicons-link-external-24: External link](https://...)` |
| Prometheus    | :simple-prometheus:         | `[:simple-prometheus: Open Prometheus](../)`               |
| Grafana       | :simple-grafana:            | `[:simple-grafana: Open Grafana](../)`                     |

### Tags

We use tags to categorize and group the content to make it easier to find, as an alternative to the navigation menu and search.

Tags are written in the front matter of the markdown file like so:

```markdown title="page.md"
---
tags: [tag1, tag2]
---

# Title

...
```

### GCP only features

Features that are only available in GCP clusters should preferably be marked in a consistent way.

For that purpose, a macro is available to add a warning in the text:

```markdown title="page.md"
# Aiven Redis

<<gcp_only("Aiven Redis")>>

Aiven Redis is ...
```


#### Which tags should I use?

Tags should group multiple related pages together.
Avoid using tags that only apply to a single page.
This helps keeping the Tags-overview page cleaner.

We typically always tag the diataxis-type the page classifies as with these mappings:

| Form         | Tag           |
|--------------|---------------|
| Explanation  | `explanation` |
| How-to guide | `how-to`      |
| Reference    | `reference`   |
| Tutorial     | `tutorial`    |
 
Tag each page with the parent category or service that it belongs to.

For example, these would be the tags for `metrics` and `tracing` in the `observability` category:

```text
observability/
├─ README.md           # tags: [observability, explanation]
├─ metrics/
│  ├─ README.md        # tags: [observability, metrics, explanation]
│  ├─ how-to/
|  |  ├─ how-to1.md    # tags: [metrics, how-to]
|  ├─ reference/
│  |  ├─ spec.md       # tags: [metrics, reference]
├─ tracing/
│  ├─ README.md        # tags: [observability, tracing, explanation]
│  ├─ how-to/
|  |  ├─ how-to1.md    # tags: [tracing, how-to]
|  ├─ reference/
│  |  ├─ spec.md       # tags: [tracing, reference]
```

## Diataxis ([https://diataxis.fr/](https://diataxis.fr/))

_Diátaxis identifies four distinct needs, and four corresponding forms of documentation - tutorials, how-to guides, technical reference and explanation. It places them in a systematic relationship, and proposes that documentation should itself be organised around the structures of those needs._

To create contents you must determine what you are setting out to do. Are you writing a _Tutorial_, a _How-to guide_, a _Reference_ or is it a comprehensive _Explanantion_ of a concept.

### [**Tutorial**](https://diataxis.fr/tutorials/)

A tutorial is an experience that takes place under the guidance of a tutor. A tutorial is always learning-oriented.

### [**How-to**](https://diataxis.fr/how-to-guides/)

How-to guides are directions that guide the reader through a problem or towards a result. How-to guides are goal-oriented.

### [**Reference**](https://diataxis.fr/reference/)

Reference guides are technical descriptions of the machinery and how to operate it. Reference material is information-oriented.

### [**Explanation**](https://diataxis.fr/explanation/)

Explanation is a discusive treatment of a subject, that permits reflection. Explanation is understanding-oriented.

