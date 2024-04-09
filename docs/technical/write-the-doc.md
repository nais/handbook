# Authoring the NAIS docs

When writing [the documentation](https://github.com/nais/doc) we serve at [doc.nais.io](https://doc.nais.io) / `doc.<tenant>.cloud.nais.io`, we want to make sure that the content we provide helps our users to understand and use the platform we're making.

Some key points to keep in mind when writing the docs are:

- [Following the diataxis theory](#diataxis-httpsdiataxisfr)
- Less is more: Keep it short and to the point. This makes it easier to sustain high quality over time.
- We are writing docs for the _users_ of our platform. No one else. We should be empathetic to their needs and understanding of the platform, and be mindful of adding details that are not relevant in the current documentation context
- [Consistency](#conventions) in style and tone
- NAIS [Quality](https://diataxis.fr/quality/)

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

### Code blocks

We want to use expanded notes with the filename in the title and the code block inside the note. Preferably with syntax highlighting where applicable.
This will give the reader a copy button with the relevant code and the filename will be visible in the navigation menu.

````markdown
???+ note ".nais/app.yaml"

    ```yaml hl_lines="6-8 11"
    apiVersion: nais.io/v1alpha1
    kind: Application
    ...
    ```
````

### Alternate paths

When the user is given a choice, we want to show both paths in the documentation. For example programming language, OS or different methods

```markdown
  === "Linux"
    linux specific stuff
  === "macOS"
    macOS specific stuff
```

### Links

With the new structure links play a big part in the documentation. We want to make sure that the links are consistent and easy to understand. We use the following structure for links:


| Type of Link  | Icon                        | Link                                                       |
| ------------- | --------------------------- | ---------------------------------------------------------- |
| Explanation   | :bulb:                      | `[:bulb: Learn more about ...](../)`                       |
| How-to guide  | :dart:                      | `[:dart: Learn how to ...](../)`                           |
| Reference     | :computer:                  | `[:computer: Reference for ](../)`                         |
| Tutorial      | :rocket:                    | `[:rocket: Tutorial for ...](../)`                         |
| Prometheus    | :simple-prometheus:         | `[:simple-prometheus: Open Prometheus](../)`               |
| Grafana       | :simple-grafana:            | `[:simple-grafana: Open Grafana](../)`                     |
| External link | :octicons-link-external-24: | `[:octicons-link-external-24: External link](https://...)` |

### Tags

We use tags to categorize and group the content.
This allows for finding related pages by tag.
Tags are written in the front matter of the markdown file:

```markdown
---
tags: [tag1, tag2]
---

# Title

...
```

Tags should be in lowercase.

Tag the form of the page. The following tags are used:

| Form         | Tag           |
|--------------|---------------|
| Explanation  | `explanation` |
| How-to guide | `guide`       |
| Reference    | `reference`   |
| Tutorial     | `tutorial`    |
