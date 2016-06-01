//rest service daemon for pdfbox2 schema.

package main

import (
	"fmt"
	"html"
	"io/ioutil"
	"net/http"
	"os"
	"os/signal"
	"runtime"
	"syscall"
	"time"
)

var listen string = ":8080";
var path_prefix = "/rest/pdfbox2/";

var (
	stderr = os.NewFile(uintptr(syscall.Stderr), "/dev/stderr")
	stdout = os.NewFile(uintptr(syscall.Stdout), "/dev/stdout")
)

type cli_arg struct {
	name	string
	pgtype	string
}

type REST_query struct {
	query_path	string
	source_path	string
}

var REST_queries = []REST_query {

	{"query/keyword",	"lib/keyword.sql"},
}

var query_keyword string;

func usage() {
	fmt.Fprintf(stderr, "usage: rest-pdfbox2\n")
}

func ERROR(format string, args ...interface{}) {

	fmt.Fprintf(
		stderr,
		"%s: rest-pdfbox2: ERROR: %s\n",
		time.Now().Format("2006/01/02 15:04:05"),
		fmt.Sprintf(format, args...),
	)
}

func log(format string, args ...interface{}) {

	fmt.Fprintf(stdout, "%s: %s\n",
		time.Now().Format("2006/01/02 15:04:05"),
		fmt.Sprintf(format, args...),
	)
}

func leave(status int) {
	log("good bye, cruel world")
	os.Exit(status);
}

func die(format string, args ...interface{}) {

	ERROR(format, args)
	leave(2)
}

func (q REST_query) load() {
	
	log("loading sql rest query: %s", q.query_path)
	log("	sql source file: %s", q.source_path)
	_, err := ioutil.ReadFile(q.source_path)
	if err != nil {
		die("%s", err)
	}
}

func main() {

	log("hello, world");

	if len(os.Args) != 1 {
		die(
			"wrong number of arguments: got %d, expected 1",
			len(os.Args),
		)
	}

	//  catch signals

	go func() {
		c := make(chan os.Signal)
		signal.Notify(c, syscall.SIGTERM)
		signal.Notify(c, syscall.SIGQUIT)
		signal.Notify(c, syscall.SIGINT)
		s := <-c
		log("caught signal: %s", s)
		leave(0)
	}()

	log("process id: %d", os.Getpid())
	log("go version: %s", runtime.Version())
	log("listen service: %s", listen)

	for _, q := range REST_queries {
		q.load()
	}

	http.HandleFunc(
		path_prefix,
		func(w http.ResponseWriter, r *http.Request,
	) {
		url :=  html.EscapeString(r.URL.String())
		fmt.Fprintf(w, "Rest: %s: %s", r.Method, url)
		log("%s: %s: %s", r.RemoteAddr, r.Method, url)
	})

	err := http.ListenAndServe(listen, nil)
	if err != nil {
		die("%s", err)
	}
	leave(0)
}