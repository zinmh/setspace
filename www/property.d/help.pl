#
#  Synopsis:
#	Write <div> help page for script property.
#  Source Path:
#	property.cgi
#  Source SHA1 Digest:
#	No SHA1 Calculated
#  Note:
#	property.d/help.pl was generated automatically by cgi2perl5.
#
#	Do not make changes directly to this script.
#

our (%QUERY_ARG);

print <<END;
<div$QUERY_ARG{id_att}$QUERY_ARG{class_att}>
END
print <<'END';
 <h1>Help Page for <code>/cgi-bin/property</code></h1>
 <div class="overview">
  <h2>Overview</h2>
  <dl>
<dt>Title</dt>
<dd>/cgi-bin/property</dd>
<dt>Synopsis</dt>
<dd>HTTP CGI Script /cgi-bin/property</dd>
<dt>Blame</dt>
<dd>jmscott</dd>
  </dl>
 </div>
 <div class="GET">
  <h2><code>GET</code> Request.</h2>
   <div class="out">
    <div class="handlers">
    <h3>Output Scripts in <code>$SERVER_ROOT/lib/property.d</code></h3>
    <dl>
     <dt>table</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>start</dt>
  <dd>
   <ul>
    <li><code>default:</code> today</li>
    <li><code>perl5_re:</code> [\w]{1,15}</li>
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
   <dt><a href="/cgi-bin/property?/cgi-bin/property?help">/cgi-bin/property?/cgi-bin/property?help</a></dt>
   <dd>Generate This Help Page for the CGI Script /cgi-bin/property</dd>
 </dl>
</div>
 </div>
</div>
END

1;
