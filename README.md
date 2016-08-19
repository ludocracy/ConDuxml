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
    <instance/> # calls #activate 
     
    