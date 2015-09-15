#
#  Synopsis:
#	Write <div> help page for script blob.
#  Source Path:
#	blob.cgi
#  Source SHA1 Digest:
#	No SHA1 Calculated
#  Note:
#	blob.d/help.pl was generated automatically by cgi2perl5.
#
#	Do not make changes directly to this script.
#

our (%QUERY_ARG);

print <<END;
<div$QUERY_ARG{id_att}$QUERY_ARG{class_att}>
END
print <<'END';
 <h1>Help Page for <code>/cgi-bin/blob</code></h1>
 <div class="overview">
  <h2>Overview</h2>
  <dl>
<dt>Title</dt>
<dd>/cgi-bin/blob</dd>
<dt>Synopsis</dt>
<dd>HTTP CGI Script /cgi-bin/blob</dd>
<dt>Blame</dt>
<dd>jmscott</dd>
  </dl>
 </div>
 <div class="GET">
  <h2><code>GET</code> Request.</h2>
   <div class="out">
    <div class="handlers">
    <h3>Output Scripts in <code>$SERVER_ROOT/lib/blob.d</code></h3>
    <dl>
     <dt>input</dt>
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
     <dt>title</dt>
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
     <dt>div.nav</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>rppg</dt>
  <dd>
   <ul>
    <li><code>default:</code> 20</li>
    <li><code>perl5_re:</code> \d{1,10}</li>
   </ul>
  </dd>
  <dt>page</dt>
  <dd>
   <ul>
    <li><code>default:</code> 1</li>
    <li><code>perl5_re:</code> [1-9]\d{0,9}</li>
   </ul>
  </dd>
  <dt>mime</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> .{0,255}</li>
   </ul>
  </dd>
  <dt>udig</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> [[:alnum:]]{1,15}:[[:graph:]]{1,255}</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
     <dt>dl</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>rppg</dt>
  <dd>
   <ul>
    <li><code>default:</code> 20</li>
    <li><code>perl5_re:</code> \d{1,10}</li>
   </ul>
  </dd>
  <dt>page</dt>
  <dd>
   <ul>
    <li><code>default:</code> 1</li>
    <li><code>perl5_re:</code> [1-9]\d{0,9}</li>
   </ul>
  </dd>
  <dt>oby</dt>
  <dd>
   <ul>
    <li><code>default:</code> dtime</li>
    <li><code>perl5_re:</code> rand|dtime|adtim|bcnta|bcntd</li>
   </ul>
  </dd>
  <dt>mime</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> .{0,255}</li>
   </ul>
  </dd>
  <dt>udig</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> [[:alnum:]]{1,15}:[[:graph:]]{1,255}</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
     <dt>select.oby</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>oby</dt>
  <dd>
   <ul>
    <li><code>default:</code> dtime</li>
    <li><code>perl5_re:</code> rand|dtime|adtim|bcnta|bcntd</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
     <dt>pre.hex</dt>
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
     <dt>pre.hex</dt>
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
     <dt>dl.detail</dt>
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
     <dt>mime</dt>
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
     <dt>a.hex</dt>
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
  </dl>
 </div>
</div>
<div class="examples">
 <h3>Examples</h3>
 <dl>
   <dt><a href="/cgi-bin/blob?/cgi-bin/blob?help">/cgi-bin/blob?/cgi-bin/blob?help</a></dt>
   <dd>Generate This Help Page for the CGI Script /cgi-bin/blob</dd>
 </dl>
</div>
 </div>
</div>
END

1;
