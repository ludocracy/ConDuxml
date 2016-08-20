ConDuxml allows Ruby-based XML transforms allowing the automation of tasks like creating documentation for a technical design captured in XML.

Features:
    - XML transforms using Ruby statements
    - Automate transforms with user input provided via XML (e.g. Ruby embedded in XML)
    - Standard transforms include transposing Ruby object or XML to table, description, map and list and hooks to custom
        ize the output
    - Reserved elements including array, instance and link can be embedded in design to trigger transforms specified by 
        subclassing them.
    - Transforms can be done in one of two output mode assumptions:
        - #instantiate creates a deep clone of the source document where nodes wrapped in \<instance>-type key 
            elements are replaced by the return value of that node's own #instantiate method call.
            you could consider this the "modification" approach to transforms.
        - #transform creates document from scratch by invoking an XML Doc starting with \<transforms> and traversing it,
         invoking each <con_duxml:transform>'s #activate method. Each transform can take Ruby-defined methods plus user-
         given args that can be passed in via the \<transform> element. The output file should have the exact 
         hierarchy of the transforms file, except for duplication of patterns from arraying.
         This is a more "generation" approach to transformation and closer to traditional XML transform behavior.
         
 List of Key elements and their behaviors:
 
 #activated by #instantiate
    \<instance/> # is replaced by a #dclone of the XML node referenced by @ref; changes to @ref are not reflected by the clone
    \<array/> # is replaced by number of copies of contents or @ref equal to @size
    \<link/> # is replaced by a transient node that reflects state of @ref'd XML node i.e. an 'alias'd object
    
 #activated by #transform
    \<transform>   # is replaced by new Element with name @name and attributes @attributes using data from @target
    \<_METHOD_>     # method can include any that return an Element; they can also return non XML objects which 
                    # automatically become arguments for their containing \<transform/>;
                    # similarly, any text content is interpreted as a block to be executed and whose return value can be
                 # accessed by its \<transform> ancestor
    
 # example of transform file and results
  - given an XML file:
    \<parent>
        \<child attr="foo"/>
    \</parent>
  - and transform file:
    \<transform target="parent" name="'root'" attributes="id: 'asdf'">
        \<transform target="parent.child" output="name">
            \<transform target="parent.child" output="child[:attr]"/>
        \</transform>
    \</transform>
    
  - you get output:
    \<root id="asdf">
        \<child>
            \<foo/>
        \</child>
    \</root>
     
    