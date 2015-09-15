#
#  Synopsis:
#	Write <div> help page for script my.
#  Source Path:
#	my.cgi
#  Source SHA1 Digest:
#	No SHA1 Calculated
#  Note:
#	my.d/help.pl was generated automatically by cgi2perl5.
#
#	Do not make changes directly to this script.
#

our (%QUERY_ARG);

print <<END;
<div$QUERY_ARG{id_att}$QUERY_ARG{class_att}>
END
print <<'END';
 <h1>Help Page for <code>/cgi-bin/my</code></h1>
 <div class="overview">
  <h2>Overview</h2>
  <dl>
<dt>Title</dt>
<dd>/cgi-bin/my</dd>
<dt>Synopsis</dt>
<dd>HTTP CGI Script /cgi-bin/my</dd>
<dt>Blame</dt>
<dd>jmscott</dd>
  </dl>
 </div>
 <div class="GET">
  <h2><code>GET</code> Request.</h2>
   <div class="out">
    <div class="handlers">
    <h3>Output Scripts in <code>$SERVER_ROOT/lib/my.d</code></h3>
    <dl>
     <dt>a</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>udig</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> [[:alnum:]]{1,15}:[[:graph:]]{1,255}</li>
   </ul>
  </dd>
  <dt>text</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> .{0,255}</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
     <dt>form</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>udig</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> [[:alnum:]]{1,15}:[[:graph:]]{1,255}</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
  </dl>
 </div>
</div>
<div class="examples">
 <h3>Examples</h3>
 <dl>
   <dt><a href="/cgi-bin/my?/cgi-bin/my?help">/cgi-bin/my?/cgi-bin/my?help</a></dt>
   <dd>Generate This Help Page for the CGI Script /cgi-bin/my</dd>
 </dl>
</div>
 </div>
</div>
END

1;
