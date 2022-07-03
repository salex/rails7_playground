###Rails 7 with Tailwindcss and Slim Templates

I'll start of with **I Hate HTML!**. I've hated it since the early 1990's when we put up one of the first websites in Alabama [AIDT.edu](https://www.aidt.edu/) using [WebSTAR](https://en.wikipedia.org/wiki/WebSTAR). The original version was just a simple *Who we are and What do we do* site. It has evolved!

I've hated it since making a poor decision in adopting a framework *(my opinion!)* [4D - 4th Dimension, or Silver Surfer](https://en.wikipedia.org/wiki/4th_Dimension_(software)) to manage AIDT's process. At first it was just a used as a local DB server. We then adopted [Active4D](https://aparajita.com/), which was a PHP like plugin for 4D. That application was on a subdomain.

I've long ago retired but before I did, we experimented with Rails, Version 0.9 for some internal projects. It never went anywhere, but it did get me hooked on Rails. After I retired I became a *hobby developer*. I developed a Rails version of the Active4D subdomain with all the things it should of had. I tried to give it to AIDT, but...

My hobby projects include:

- [rBooks](https://github.com/salex/rbooks) which is a web-based double entry accounting system I build for myself. I joined the VFW (Veterans of Foreign Wars) and became the Quartermaster (accountant!). I was not going to use paper ledgers. The github page give a little more background on me and the different phases of rBooks. 
- Another VFW site I used to manage a few other things at my post (members, reports etc.) It had some *blog* like pages, but then came Facebook!
- PTGolf.us - a golf group dogfight point management system (Groups/Players/Games/Rounds). It actually started as a backdoor page on one of the servers at AIDT.

#### Slim

Somewhere about 10 year ago I put away my hate HTML when I discovered haml, and then slim. I can manage indented tabs a lot better than I could HTML tags. My three project started about Rails 3 and went through 4, 5 and 6. I've spent the last 6 month moving them to Rails 7.  Not an easy task! I added Tailwindcss and I'm slowly moving from W3.css. I've also gone through CSS hell trying different stuff. Zurb Foundation which something was always broke! That forced me to plain old W3.css.

As I moved to Rails 7 and added Tailwind, Rails would muckup the application layout page and add:

```html
<body>
  <main class="container mx-auto mt-16 px-5 flex">
    <%= yield %>
  </main>
```

That worked fine for erb scaffolds, providing workable ( prettier ) CRUD scaffold views. Not so good with Slim. Since my 3 project views have long ago were moved to different layouts. I'll point out that the majority of the view are table based and that was eliminated in the Rails 7 scaffolds.

Running out of things to do, I though about rewriting rBooks and removing the VFW flavor and refactoring a bunch of junk code. Instead of removing the Tailwind stuff in the layout I tried to work with it and create Slim template that kinda matched the erb layout.

I remember doing that years ago, probably using erb, then running the erb through some *html2slim* processor. But I gave it another try, modifying slim-rails layout templates to include some tailwind.

There were a few links how to had lib/templates/slim/scaffold [Working with Custom Rails Scaffolding Templates in Slim](https://medium.com/@thetrevorharmon/working-with-custom-rails-scaffolding-templates-in-slim-ea49430bafa3). It's several year old and seems to have lost some gists, but it was enough to start.

One of the things I don't like about Tailwind is a basic class for some things like buttons. I understand the tailwind concept of just using their classes to style a button, but adding:

```html
= link_to 'something',some_path,class="ml-2 rounded-md py-1 px-3 bg-gray-200 inline-block font-medium "
```

Gets old. I wrote a post a while back [Mimic Tailwind components in Rails using Helpers
](https://dev.to/salex/mimic-tailwind-components-in-rail-using-helpers-1b1o). I think I only used it on one model/views that I was refactoring. Above like would become:

```html
= link_to 'something',some_path,class="#{btn-sm-blue} "
```
which would call a method in:

```ruby
module ButtonHelper
  def btn_lg
    "ml-2 rounded-xl py-5 px-7 bg-gray-200 inline-block font-medium "
  end
  def btn_md
    "ml-2 rounded-lg py-3 px-5 bg-gray-200 inline-block font-medium "
  end
  def btn_sm
    "ml-2 rounded-md py-1 px-3 bg-gray-200 inline-block font-medium "
  end 
  def btn_submit
    "mt-2 rounded-md py-4 px-6 bg-blue-700 text-white hover:bg-blue-600 inline-block font-medium"
  end
  def btn_sm_blue
    btn_sm + "bg-blue-200 hover:bg-blue-300 "
  end
  def btn_sm_red
    btn_sm + "bg-red-700 hover:bg-red-800 text-white "
  end
  def btn_sm_green
    btn_sm + "bg-green-200 hover:bg-green-300 "
  end

  def icon(klass, text = nil)
    icon_tag = tag.i(class: klass)
    text_tag = tag.span text
    text ? tag.span(icon_tag + text_tag) : icon_tag
  end

end

```

My slim templates are going to require this helper. I've also added fontawsome icons, if you don't use it they'll just be ignored.

After writing the helper my process was:

Copy the scaffold templates from the [slim_rails gem](https://github.com/slim-template/slim-rails/tree/master/lib/generators/slim/scaffold/templates) to your lib/templates/slim/scaffold directory.

From the post I mentioned: You need to tell rails explicitly to use slim when scaffolding views. Open upapplication.rb and in your Class Application < Rails::Application add:

```ruby
config.generators do |g|
   g.template_engine :slim
end
```

Go through a laborious process and making the slim template produce something like the erb templates. That may include many 'bin/rail g scaffold thing date title content
' followed by bin/rails destroy scaffold thing, deleting the table etc. 

An example of a template looks like:

```ruby
div.w-full
  p style="color: green" = notice
  h1.font-bold.text-2xl Showing <%= human_name.capitalize %>

  div.flex.gap-8
    => link_to icon('fas fa-edit',"Edit <%= human_name.capitalize %>"), <%= edit_helper(type: :path) %>, class:"#{btn_sm_green}"
    =< link_to icon('fas fa-list',"List <%= human_name.pluralize.capitalize %>"), <%= index_helper(type: :path) %>, class:"#{btn_sm_green}"
    = button_to icon('fas fa-trash',"Destroy <%= human_name.capitalize %>"), <%= model_resource_name(prefix: "@") %>, method: :delete, form:{data: { turbo_confirm: 'Are you sure?', turbo_method:'delete' }}, class:"#{btn_sm} bg-red-700 text-white"
  hr.border-1.border-blue-500.my-1
  == render @<%= singular_table_name %>

```

All 6 file are in a [gist](https://gist.github.com/salex/d77c95096597109aa47498629c5e21d8)