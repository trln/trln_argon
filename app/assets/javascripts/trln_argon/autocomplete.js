/*global Bloodhound */

Blacklight.onLoad(function() {
  'use strict';

  $('[data-autocomplete-enabled="true"]').each(function() {
    var $el = $(this);

    var sharedData = $("#shared-application-data").data();

    // Fetch the configured autocomplete path.
    var suggest_root = $el.data().autocompletePath;

    // ======= Advanced search =================
    if ($("#advanced_search").length){
      // Detect which search field is selected.
      var current_search_field = $el.attr('name');

      // Assemble the complete autosuggest URL.
      var suggest_url = suggest_root + "/" + current_search_field;

      //Detect local institution code
      var local_institution_code = sharedData.localInstitution;

      $('input[type=radio][name=option]').change(function(){
        if ($('input[type=radio][name=option]:checked').attr('id') == "option_trln") {
          local_institution_code = "unc||ncsu||duke||nccu";
        }
      });
    } else if ($("#search-navbar").length){

      // ======= Main search ======================
      var suggest_slug = '';

      // Detect which search field is selected.
      var current_search_field = $("select").find("option:selected").val();

      //Detect local institution code
      var local_institution_code = "unc||ncsu||duke||nccu";
      if ($("body").hasClass("blacklight-catalog")) {
        local_institution_code = sharedData.localInstitution;
      }

      // Set the autocomplete URL slug/ID based on the selected search field.
      switch (current_search_field) {
        case 'title':
          suggest_slug = '/title';
          break;
        case 'author':
          suggest_slug = '/author';
          break;
        case 'subject':
          suggest_slug = '/subject';
          break;
      }
      // Assemble the complete autosuggest URL.
      var suggest_url = suggest_root + suggest_slug;
    }

    // Configure the request for title suggestions
    var titles = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggest_url + '?q=%QUERY',
        wildcard: '%QUERY',
        filter: function(response){
          return response.title;
        },
        replace: function(url, uri_encoded_query) {
          var new_url = suggest_url + '?q=' + uri_encoded_query + '&institution=' + local_institution_code;
          return new_url;
        }
      }
    });

    // Configure the request for author suggestions
    var authors = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggest_url + '?q=%QUERY',
        wildcard: '%QUERY',
        filter: function(response) {
          return response.author;
        },
        replace: function(url, uri_encoded_query) {
          var new_url = suggest_url + '?q=' + uri_encoded_query + '&institution=' + local_institution_code;
          return new_url;
        }
      }
    });

    // Configure the request for subject suggestions
    var subjects = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggest_url + '?q=%QUERY',
        wildcard: '%QUERY',
        filter: function(response){
          return response.subject;
        },
        replace: function(url, uri_encoded_query) {
          var new_url = suggest_url + '?q=' + uri_encoded_query + '&institution=' + local_institution_code;
          return new_url;
        }
      }
    });

    // Set the typeahead options
    var options = {
      hint: true,
      highlight: true,
      minLength: 3
    };

    // Shared suggestion template
    function suggestion_template(data) {
      return '<p class="' + data.category + '">' + data.term + ' <span class="tt-category">' + data.category + '</span></p>';
    }

    // Set the typeahead datasets.
    var datasets = [{
      name: 'titles',
      displayKey: 'term',
      source: titles.ttAdapter(),
      templates: {
        suggestion: function (data) {
          return suggestion_template(data);
        }
      }
    },
    {
      name: 'authors',
      displayKey: 'term',
      source: authors.ttAdapter(),
      templates: {
        suggestion: function (data) {
          return suggestion_template(data);
        }
      }
    },
    {
      name: 'subjects',
      displayKey: 'term',
      source: subjects.ttAdapter(),
      templates: {
        suggestion: function (data) {
          return suggestion_template(data);
        }
      }
    }];

    // Listen for change to selected search field
    $("#search-navbar select").on("change", function() {
      current_search_field = this.value;

      // remove any existing .on() listeners attached to
      // typeahead:open. This prevents the listener from
      // switching the search field back to all fields at the
      // wrong time.
      $el.off('typeahead:open');

      // Generalized method for destroying and then
      // reinitializing the typeahead engine with a
      // different suggest URL.
      function reinit_typeahead(suggest_slug) {
        $el.typeahead('destroy');
        suggest_url = suggest_root + suggest_slug;
        $el.typeahead(options, datasets);
      }

      // Reinitialize the typeahead engine with the
      // suggest path set appropriately for the
      // currently selected search field.
      switch (current_search_field) {
        case 'title':
          reinit_typeahead('/title');
          break;
        case 'author':
          reinit_typeahead('/author');
          break;
        case 'subject':
          reinit_typeahead('/subject');
          break;
        case 'all_fields':
          reinit_typeahead('');
          break;
        default:
          // If the selected search field is something other than
          // one of the above fields then destroy the typeahead engine.
          // We don't want to show it for ISBN search for example. It will
          // turn back on if another field is selected.
          $el.typeahead('destroy');
      }

      // Add any previously entered search back into
      // the typehead widget.
      var prev_query = $el.typeahead('val');
      $el.typeahead('val', '').typeahead('val', prev_query);
    });

    // Detect when a typeahead suggestion is selected and
    // set the search field selector to the appropriate field
    // if the current field is all_fields.
    $el.on('typeahead:select', function(ev, data) {
      function switch_selected_field(field) {
        $('select[name=search_field]').val(field);
        $('.selectpicker').selectpicker('refresh');
      }

      if (current_search_field == 'all_fields') {
        switch_selected_field(data.category);

        // Listen for event that indicates the user changed their
        // mind and switch the selector back to all_fields.
        $el.on('typeahead:open', function(ev, data){
          switch_selected_field('all_fields');
        });
      }
    });

    // Initialize typeahead for only these fields.
    if (current_search_field == 'title' ||
        current_search_field == 'author' ||
        current_search_field == 'subject' ||
        current_search_field == 'all_fields') {
      $el.typeahead(options, datasets);
    }
  });
});
