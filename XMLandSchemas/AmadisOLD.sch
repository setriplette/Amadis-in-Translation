<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
  <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>   
<!--2017-03-12 ebb: This is the original schema for the Amadis project, before we implemented a TEI ODD. 
    We no longer need to use it, now that we have implemented a TEI ODD-generated schema.
    We'll keep this file in the GitHub repository in case we need to check our original rules to update the ODD. -->
  <pattern>
    <rule context="tei:milestone">
      <assert test="@unit = ('p','said')">
        "said" and "p" are the only permitted values of @unit on the milestone element. 
      </assert>
    </rule>
  </pattern>
  
  <pattern>
    <rule context="tei:milestone[@unit eq 'said'] | tei:anchor">
      <report test="not(@ana)">
        An @ana must be present to designate the start or end (or interruption) of a speech or unit of translation.
      </report>     
    </rule> 
  </pattern>

  <pattern>
    <rule context="tei:anchor[@ana eq 'start'][not(@type eq 'add')]">
      <report test="not(@corresp)">
        A @corresp must be present on this anchor to point to a corresponding unit in Montalvo! This rule applies as long as the anchor is NOT an addition by Southey (@type="add"). 
      </report>
    </rule>
  </pattern>
  
  <pattern>
    <rule context="tei:milestone[@unit eq 'said'] | tei:anchor">
      <assert test="@ana = ('start','end','intStart','intEnd')">
        Legitimate values for @ana are "start," "end," "intStart," and "intEnd."
      </assert>
    </rule>
  </pattern>
  
  <pattern>
    <rule context="tei:anchor[@type]">
      <assert test="@type = ('add','report','direct')">
        When using an @type attribute on the anchor element, legitimate values are "add," "direct" and "report."
      </assert>
    </rule>
  </pattern>
  
  <pattern>
    <rule context="tei:milestone[@unit eq 'said'][@ana eq 'start']">
      <assert test="@resp">
        A milestone marking the start of a speech must always have an @resp attribute pointing to the #xml:id for the speaker.
      </assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:milestone[@unit eq 'said'][@ana eq 'start'][@type]">
      <assert test="@type eq 'unclear'">
        When the @resp is hard to attribute, add a @cert whose value should be “low“ or “medium,” if you suggest a speaker, or “unknown,” if you don't.
      </assert>
    </rule>
  </pattern>
  
  <pattern> 
    <rule context="tei:milestone[@unit eq 'said'][@ana][preceding::tei:milestone[@unit eq 'said'][@ana]]/@ana">
      <report test="matches(., preceding::tei:milestone[@unit eq 'said'][@ana][1]/@ana)">
        For speeches: the @ana must NOT be the same on two subsequent milestones!
      </report>   
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:milestone[@unit eq 'said'][@ana eq 'start']">
      <report test="./following::tei:milestone[@unit eq 'said'][@ana][1][@ana eq 'intEnd']">
        In tagging speeches, the value of @ana for the next milestone after "start" must never be "intEnd"!
      </report>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:milestone[@unit eq 'said'][@ana eq 'intStart']">
      <assert test="./following::tei:milestone[@unit eq 'said'][@ana][1][@ana eq 'intEnd']">
        For speeches: After an @ana="intStart" (interruption start) the next @ana must be "intEnd" (interruption end)!
      </assert>
      
    </rule>
  </pattern>
  
  <pattern> 
    <rule context="tei:anchor[@ana][not(ancestor::tei:note)][preceding::tei:anchor[@ana][not(ancestor::tei:note)]]/@ana">
      <report test="matches(., preceding::tei:anchor[@ana][not(ancestor::tei:note)][1]/@ana)">
        The @ana must NOT be the same on two subsequent anchor elements in the main text!
      </report>   
    </rule>
    <rule context="tei:anchor[@ana][ancestor::tei:note][preceding::tei:anchor[@ana][ancestor::tei:note]]/@ana">
      <report test="matches(., preceding::tei:anchor[@ana][ancestor::tei:note][1]/@ana)">
        The @ana must NOT be the same on two subsequent anchor elements within a note!
      </report>   
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:anchor[@ana eq 'start'][not(ancestor::tei:note)]">
      <report test="following::tei:anchor[@ana][not(ancestor::tei:note)][1][@ana eq 'intEnd']">
        In tagging a disconnected (interrupted) series of translations in the main text, the value of @ana for the next anchor after "start" must never be "intEnd"!
      </report>
    </rule>
    <rule context="tei:anchor[@ana eq 'start'][ancestor::tei:note]">
      <report test="following::tei:anchor[@ana][ancestor::tei:note][1][@ana eq 'intEnd']">
        In tagging a disconnected (interrupted) series of translations within a note, the value of @ana for the next milestone after "start" must never be "intEnd"!
      </report>
    </rule>   
  </pattern>
  <pattern>
    <rule context="tei:anchor[@ana eq 'start'][not(parent::tei:note)]">
      <assert test="following::tei:anchor[@ana eq 'end'][not(parent::tei:note)][1]/parent::node()/name() eq current()/parent::node()/name()">
        Every anchor[@ana='start'] must have a correlating anchor[@ana='end'] with the same kind of parent element. 
      This prevents ambiguous pairings of anchor elements between main text and notes.</assert>
    </rule>
    <rule context="tei:anchor[@ana eq 'start'][parent::tei:note]">
      <assert test="following-sibling::tei:anchor[@ana eq 'end']">Every anchor[@ana='start'] inside a note must have an anchor[@ana='end'] within the same parent.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:anchor[@ana eq 'intStart'][not(ancestor::tei:note)]">
      <assert test="following::tei:anchor[@ana][not(ancestor::tei:note)][1][@ana eq 'intEnd']">
        After an @ana="intStart" (interruption start) in the main text, the next @ana must be "intEnd" (interruption end)!
      </assert>
    </rule>
    <rule context="tei:anchor[@ana eq 'intStart'][ancestor::tei:note]">
      <assert test="following::tei:anchor[@ana][ancestor::tei:note][1][@ana eq 'intEnd']">
        After an @ana="intStart" (interruption start) in a note, the next @ana must be "intEnd" (interruption end)!
      </assert>
    </rule>
  </pattern>

  
  <pattern>
    <rule context="tei:cl">
      <report test=".//tei:cl">Nested clauses!</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="tei:cl[preceding::tei:cl]">
      <assert test="number(substring-after(@xml:id, '_c')) gt number(substring-after(preceding::tei:cl[1]/@xml:id, '_c'))">
        The clause number on the xml:id (even when a decimal) should be larger than the clause number on the preceding @xml:id.
      </assert>
    </rule>
  </pattern>
  
  <pattern>
    <rule context="tei:seg">
      <assert test="contains(@xml:id, parent::tei:cl/@xml:id)">
        A seg's @xml:id must contain the @xml:id of its cl parent. 
      </assert>
    </rule>
  </pattern>
 
  
  <!--ebb 2015-08-27 Rules for Pointing to Other Files and xml:ids-->
  
  <let name="si" value="doc('SI-Amadis.xml')//@xml:id"/>
  <let name="siFile" value="doc('SI-Amadis.xml')"/>
  
  <let name="M_files" value="collection('./Montalvo')[contains(tokenize(./base-uri(), '/')[last()], 'Mont')]"/>
  <let name="M_ids" value="$M_files//@xml:id"/>
  
  <let name="S_files" value="collection('./Southey')[contains(tokenize(./base-uri(), '/')[last()], 'South')]"/>
  <let name="S_ids" value="$S_files//@xml:id"/>

  
  <pattern>
    <rule context="@ref | @resp">
      <let name="tokens" value="for $i in tokenize(., '\s+') return substring-after($i,'#')"/>
      <assert test="every $token in $tokens satisfies $token = $si">The attribute (after the hashtag, #) must match a defined @xml:id in the Site Index file!</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:anchor[@corresp]">
      <let name="tokens" value="for $i in tokenize(@corresp, '\s+') return substring-after($i,'#')"/>
      <assert test="every $token in $tokens satisfies $token = $M_ids">The attribute (after the hashtag, #) must match a defined @xml:id in the corresponding Montalvo 1547 edition file!</assert>
      <report test="./@corresp = following::tei:anchor/@corresp">Every anchor must have a unique ID. Add a seg element in Montalvo with its own ID if needed</report>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:div[@type eq 'chapter']">
      <assert test="@xml:id">
        The chapter div element must contain an @xml:id.
      </assert>
      <report test="@xml:id = $M_ids[not(base-uri() eq current()/base-uri())] | $S_ids[not(base-uri() eq current()/base-uri())]">
        Fix the xml:id! The xml:id on this document matches another xml:id defined on a different file!
      </report>
      <!--<report test="@xml:id = $S_ids[base-uri() ne ./base-uri()]">
          Fix the xml:id! The xml:id on this document matches another xml:id defined on a different file!
          </report>-->
    </rule>
    <rule context="tei:div[@type eq 'chapter'][contains(tokenize(./base-uri(), '/')[last()], 'Mont')]/@xml:id">
      <assert test="starts-with(., 'M')">
        The xml:id defined for a Montalvo chapter must begin with the letter M. 
      </assert>
    </rule>
    <rule context="tei:div[@type eq 'chapter'][contains(tokenize(./base-uri(), '/')[last()], 'South')]/@xml:id">
      <assert test="starts-with(., 'S')">
        The xml:id defined for a Southey chapter must begin with the letter S. 
      </assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:div[@type eq 'chapter']/@xml:id[contains(., 'M')][not(. eq'M0')]">
      <let name="M_C" value="substring-after(., 'M')"/>
      <let name="M_Cnum" value="number($M_C)"/>
      <xsl:variable name="Roman_Cnum">
        <xsl:number value="$M_Cnum" format="I"/>
      </xsl:variable>
      <!-- I think the following might be more concisely and clearly        -->
      <!-- specified as                                                     -->
      <!-- tokenize(parent::tei:div/tei:head/string(),' ')[2] eq $Roman_Cnum-->
      <!-- but I'm not sure, and would need to test; but I'd be inclined to -->
      <!-- add normalize-space(), too. -sb                                  -->
      <assert test="if (parent::tei:div/tei:head[tei:choice]) then tokenize(parent::tei:div/tei:head//tei:reg/string(),' ')[2] eq $Roman_Cnum else compare(tokenize(parent::tei:div/tei:head/string(), ' ')[2], $Roman_Cnum) eq 0">
      The @xml:id isn't matching the Roman numeral chapter number given in the head element on this Chapter div. One of these must be wrong: check what chapter you're actually working on!</assert>
      <assert test="contains(tokenize(base-uri(), '_')[last()], $M_C)">
        The chapter number in this file name doesn't match the @xml:id. One of these must be wrong: check what chapter you're actually working on!
      </assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="tei:div[@type eq 'chapter']/@xml:id[contains(., 'S')]">
      <let name="S_Cnum" value="substring-after(., 'S')"/>
      <assert test="contains(parent::tei:div/tei:head/string(), $S_Cnum)">
        The @xml:id isn't matching the chapter number given in the head element on this Chapter div. One of these must be wrong: check what chapter you're actually working on!
      </assert>
      <assert test="contains(tokenize(base-uri(), '_')[last()], $S_Cnum)">
        The chapter number in this file name doesn't match the @xml:id. One of these must be wrong: check what chapter you're actually working on!
      </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="tei:div[@type eq 'chapter'][@xml:id[contains(., 'M')]]/tei:head/tei:locus">
      <assert test="matches(@from, '[ivxlcdm]+\-(r|v)$') and matches(@to, '[ivxlcdm]+\-(r|v)$')">The number of folia must be coded as a Roman numeral (lower case), followed by a hyphen and either the letter 'r' or 'v'</assert>
    </rule>
  </pattern>
</schema>
