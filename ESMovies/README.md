# Elasticsearch
> Elasticsearch is a real-time distributed open source full-text search and analytics engine. It is accessible from RESTful web service APIs and uses JSON (JavaScript Object Notation) documents to store data. Because Elasticsearch is built on the Java programming language, it can run on different platforms. It enables users to explore very large amount of data at very high speed.

1. **A node is a single instance of Elasticsearch; it usually runs one instance per machine.**
1. **An index structure is defined by a mapping, which is a JSON file describing both the document characteristics and the index options such as the replication factor.**
1. **An index is split into shards (default is 5), and the shards are located in different nodes. The number of primary shards cannot be changed once an index has been created without reindexing.**
1. **Each shard can have zero or more replicas (default is 1). Elasticsearch ensures that both primary and replica of the same shard are not colocated in the same node.**
1. **As with shards, the number of replicas is defined when creating an index. The default number of replicas is one per shard. This means that by default, a cluster consisting of more than one node, will have 5 primary shards and 5 replicas, totalling 10 shards per index. The purpose of replication is to ensure high availability, to improve search query performance, and to be more fault tolerant. Replicas are never stored on the same node with its primary shard.**
1. **Documents are hashed to a particular shard. This ensure an even distribution of the documents among the shards.**
1. **Each shard may be on a different node in a cluster.**
1. **Every shard is a self-contained Lucene index; Lucene is the name of the search engine that powers Elasticsearch.**
1. **A Lucene index is made up of multiple segments and a segment is a fully functional inverted index in itself.**
1. **An inverted index is designed to serve low latency search results. A document is the unit of data in Elasticsearch, and an inverted index is created by tokenizing the terms in the document, creating a sorted list of all unique terms and associating a list of documents with where the word can be found. It is very similar to an index at the back of a book which contains all the unique words in the book and a list of pages where we can find that word. When we say a document is indexed, we refer to the inverted index.**
1. **Segments are immutable which allows Lucene to add new documents to the index incrementally without rebuilding the index from scratch.**
1. **Lucene occasionally merges segments according to its merge policy as new segments are added. When segments are merged, documents marked as deleted are finally discarded. This is why adding more documents can actually result in a smaller index size: it can trigger a merge.**
1. **Write requests are routed to the primary shard, then replicated.**
1. **Read requests are routed to the primary or any replica.**
1. **More replica shards can be added to increase the read throughput.**

## SQL vs Elasticsearch
--------------------
| SQL | Elasticsearch | Description |
|:---|:-------------|:-----------|
| Column  | Field   | In SQL, a column is a set of data values of the same data type. In Elasticsearch, a field can contain multiple values of the same data type (list).|
| Row     | Document| In SQL, a row is a data record within a table. In Elasticsearch, a document (expressed in JSON) is a basic unit of information that can be indexed.|
| Table   | Index   | In SQl, a table consists of rows and columns. In Elasticsearch, an index is a collection of different type of documents and their properties.|
| Schema  | Mapping | In SQL, a schema is a collection of database objects including tables, views, triggers, stored procedures, indexes, etc. In Elasticsearch, mapping is the process of defining how a document, and the fields it contains, are stored and indexed.|
| Database| Cluster | In SQL, a database represents a set of schemas. In Elasticsearch, a cluster contains a set of indexes.|

# Mapping
> Within a search engine, mapping defines how a document is indexed and how its fields are indexed and stored. We can compare mapping to a database schema in how it describes the fields and properties that documents hold, the datatype of each field (e.g., string, integer, or date), and how those fields should be indexed and stored by Lucene.

Elasticsearch supports two types of mappings: *"Static Mapping"* and *"Dynamic Mapping."* Static Mapping is used to define the index and data types. However, there is still a need for ongoing flexibility so that documents can store extra attributes. To handle such cases, Elasticsearch comes with the dynamic mapping option.

**Static Mapping**
In a normal scenario, it is known well in advance which kind of data will be stored in the document; hence, the fields and their types can be easily defined when creating the index.

**Dynamic Mapping**
When a document is index without mapping, Elasticsearch will automatically create a mapping by using predefined custom rules. New fields can be added both to the top-level mapping type and to inner objects and nested fields. In addition, dynamic mapping rules can be configured to customize the existing mapping.

**The put mapping API requires an existing index. The following create index API request creates the movies-eng index with no mapping.**  
Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng" -Method PUT -ContentType "application/json; charset=utf-8";
```JSON
$body ='
{
  "dynamic": "strict",
  "_source": {"enabled": true},
  "properties":
  {
    "title": {"type": "text", "index": true, "analyzer": "english", "fields": {"exact": {"type": "keyword"}}},
    "genres": {"type": "text", "index": true, "analyzer": "english", "norms": false},
    "description": {"type": "text", "index": true, "analyzer": "english", "norms": false},
    "cast_and_crew":
    {
      "type": "nested",
      "properties":
      {
        "full_name": {"type": "text", "index": true, "analyzer": "english", "norms": false},
        "gender": {"type": "text", "index": true, "analyzer": "english", "norms": false},
        "role": {"type": "text", "index": true, "analyzer": "english", "norms": false}
      }
    },
    "rating": {"type": "text", "index": true, "analyzer": "english", "norms": false},
    "studio": {"type": "text", "index": true, "analyzer": "english", "norms": false},
    "languages": {"type": "text", "index": true, "analyzer": "english", "norms": false},
    "subtitles": {"type": "text", "index": true, "analyzer": "english", "norms": false},
    "location": {"type": "text", "index": true, "analyzer": "english", "norms": false, "index_options": "docs"},
    "release_date": {"type": "date", "index": true, "format": "strict_year_month_day||strict_year_month||strict_year", "null_value": "9999"},
    "feature_length_min": {"type": "integer", "index": false},
    "format": {"type": "text", "index": true, "analyzer": "english", "norms": false, "index_options": "docs"}
  }
}';
```
**The following put mapping API request adds the mapping to the index.**  
Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_mapping" -Method PUT -ContentType "application/json; charset=utf-8" -Body $body;

**Below is an example of mapping creation using an index API.**
```JSON
$body ='
{
  "mappings":  # Add...
  {
    "dynamic": "strict",
    "properties":
    {
      "title": {"type": "text"},
      "genres": {"type": "text"}
      # Rest of the entries...
    }
  }
}'
```
Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng" -Method PUT -ContentType "application/json; charset=utf-8" -Body $body;

**To see the mapping**  
curl -X GET "http://elasticsearch.dev.local/movie-eng/_mapping"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_mapping/?pretty" -Method GET).Content;

# Insertion
```JSON
$body='
{
  "title": "Les Misérables",
  "genres": "Comedy, Musical",
  "description": "In 19th-century France, Jean Valjean, who for decades has been hunted by the ruthless policeman Javert after breaking parole, agrees to care for a factory worker''s daughter. The decision changes their lives forever.",
  "cast_and_crew":
  [
    {"full_name": "Hugh Jackman", "gender": "Male", "role": "Actor"},
    {"full_name": "Russell Crowe", "gender": "Male", "role": "Actor"},
    {"full_name": "Anne Hathaway", "gender": "Female", "role": "Actress"},
    {"full_name": "Amanda Seyfried", "gender": "Female", "role": "Actress"},
    {"full_name": "Tom Hooper", "gender": "Male", "role": "Director"}
  ],
  "rating": "PG-13",
  "studio": "Universal Pictures",
  "languages": "English DTS-HD Master Audio 7.1, English Dolby Digital 2.0, English Dolby Digital 5.1",
  "subtitles": "English SDH, Spanish, French",
  "location": "19th-century France",
  "release_date": "2012-12-25",
  "feature_length_min": 158,
  "format": "Blu-ray, DVD"
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_doc" -Method POST -ContentType "application/json; charset=utf-8" -Body $body).Content;

## Bulk Insertion
> It performs multiple indexing or delete operations in a single API call. This reduces overhead and can greatly increase indexing speed.

Bulk insertion provides a way to perform multiple *index*, *create*, *delete*, and *update* actions in a single request. The actions are specified in the request body using a newline delimited JSON (NDJSON) structure:  
**action_and_meta_data\n  
optional_source\n  
action_and_meta_data\n  
optional_source\n  
...  
action_and_meta_data\n  
optional_source\n**

```JSON
$body ='
{"index": {}}
{"title": "Les Misérables", "genres": "Comedy, Musical", "description": "In 19th-century France, Jean Valjean, who for decades has been hunted by the ruthless policeman Javert after breaking parole, agrees to care for a factory worker''s daughter. The decision changes their lives forever.", "cast_and_crew": [{"full_name": "Hugh Jackman", "gender": "Male", "role": "Actor"}, {"full_name": "Russell Crowe", "gender": "Male", "role": "Actor"}, {"full_name": "Anne Hathaway", "gender": "Female", "role": "Actress"}, {"full_name": "Amanda Seyfried", "gender": "Female", "role": "Actress"}, {"full_name": "Tom Hooper", "gender": "Male", "role": "Director"}], "rating": "PG-13", "studio": "Universal Pictures", "languages": "English DTS-HD Master Audio 7.1, English Dolby Digital 2.0, English Dolby Digital 5.1", "subtitles": "English SDH, Spanish, French", "location": "19th-century France", "release_date": "2012-12-25", "feature_length_min": 158, "format": "Blu-ray, DVD"}
{"index": {}}
{"title": "Valkyrie", "genres": "War, History", "description": "At the height of WWII, a group of German officers hatched a plot to assassinate Hitler and seize control of the military command in order to end the war.", "cast_and_crew": [{"full_name": "Tom Cruise", "gender": "Male", "role": "Actor"}, {"full_name": "Kenneth Branagh", "gender": "Male", "role": "Actor"}, {"full_name": "Bill Nighy", "gender": "Male", "role": "Actor"}, {"full_name": "Tom Wilkinson", "gender": "Male", "role": "Actor"}, {"full_name": "Terence Stamp", "gender": "Male", "role": "Actor"}, {"full_name": "Bryan Singer", "gender": "Male", "role": "Director"}], "rating": "PG-13", "studio": "United Artists", "languages": "English 5.1 DTS-HD Master Audio, Spanish 5.1 Dolby Digital, French 5.1 Dolby Digital", "subtitles": "English, Spanish, French, Cantonese, Mandarin, Portuguese, Korean", "release_date": "2008-12-25", "feature_length_min": 120, "format": "Blu-ray, DVD"}
{"index": {}}
{"title": "Patton", "genres": "War, History", "description": "This critically acclaimed, 1970 Best Picture Academy Award® Winner is a riveting portrait of one of the 20th century''s greatest military geniuses. The only Allied general truly feared by the Nazis, George S. Patton (George C. Scott in a Best Actor OSCAR®-winning performance), Patton out-maneuvered Rommel in Africa, and after D-Day led his troops in an unstoppable campaign across Europe.", "cast_and_crew": [{"full_name": "George C. Scott", "gender": "Male", "role": "Actor"}, {"full_name": "Karl Malden", "gender": "Male", "role": "Actor"}, {"full_name": "Franklin J. Schaffner", "gender": "Male", "role": "Director"}], "rating": "PG", "studio": "20th Century Fox", "languages": "English 5.1 Dolby Surround, English Dolby Surround, French Mono", "subtitles": "English, Spanish", "release_date": "1970", "feature_length_min": 170, "format": "DVD"}
';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_bulk" -Method POST -ContentType "application/json; charset=utf-8" -Body $body).Content;

If the data are in a file, provide the path to the file.  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_bulk" -Method POST -ContentType "application/json; charset=utf-8" -Body (Get-Content -Path "./ElasticSearch/es_bulk_insertion.txt" -Raw)).Content;

# Deletion
> TBD

## Delete by Query
The simplest usage of *_delete_by_query* just performs a deletion on every document that match a query.
```JSON
$body ='
{
  "query":
  {
    "match": {"title": "Valkyrie"}
  }
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_delete_by_query/?pretty" -Method POST -ContentType "application/json; charset=utf-8" -Body $body).Content;

This query will delete all the documents from the index.
```JSON
$body ='
{
  "query":
  {
    "match_all": {}
  }
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_delete_by_query/?pretty" -Method POST -ContentType "application/json; charset=utf-8" -Body $body).Content;


https://www.elastic.co/guide/en/elasticsearch/reference/6.4/docs-delete-by-query.html


# Queries
## Match Query Clause
> It is used to search both **analyzed** and **not_analyzed** fields. When searching an **analyzed** field, the query string will undergo the same analysis process as the field to which the query is applied (analyzed search). When searching a **not_analyzed** field (exact value), it performs a **filter**.

Return at most 2 (defaults to 10) documents.  
curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?size=2&pretty" -H "Content-Type: application/json" -d "{\\"query\\": {\\"match\\": {\\"description\\": \\"critically acclaimed\\"}}}"
```JSON
$body ='
{
  "query":
  {
    "match": {"description": "critically acclaimed"}
  }
}';
```
The next query is the same as the previous, but the following requirements were specified:
1. **size** - Specify the number of documents to return (default is 10).
1. **from** - The offset to start from (useful for pagination).
1. **_source** - The fields to be returned.
1. **highlight** - Term highlighting.
```JSON
$body ='
{
  "query":
  {
    "match": {"description": "critically acclaimed"}
  },
  "size": 2,
  "from": 0,
  "_source": ["title", "description", "release_date"],
  "highlight":
  {
    "fields": {"description": {}}
  }
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search/?size=2&pretty" -Headers @{'Content-Type'='application/json; charset=utf-8'} -Method POST -Body $body).Content;

## Match All Query Clause
> It returns all of the documents from the given index.

curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"match_all\\": {} }}"
```JSON
$body ='
{
  "query":
  {
    "match_all": {}
  },
  "from": 0,
  "size": 500,
  "_source": ["title", "rating", "release_date"]
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -Headers @{'Content-Type'='application/json; charset=utf-8'} -Method POST -Body $body).Content;

## Match Phrase Query
> It is used when there is a need to match the exact phrase against a field; i.e., when the order of the terms in the query matter.

curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"match_phrase\\": { \\"languages\\": \\"English DTS-HD Master Audio 7.1\\" } }}"
```JSON
$body ='
{
  "query":
  {
    "match_phrase": { "languages": "English DTS-HD Master Audio 7.1" }
  }
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -Headers @{'Content-Type'='application/json; charset=utf-8'} -Method POST -Body $body).Content;

## Term/Terms Queries Clause
> These queries are used for structured searches in which an exact match is required; i.e., they mainly deal with structured data like numbers, dates, and enums.

curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"term\\": { \\"release_date\\": \\"1970\\" }}}"
```JSON
$body ='
{
  "query":
  {
    "term": { "release_date": "1970" }
  },
  "_source": ["title", "release_date", "format"]
}';
```
For multiple terms, use the **terms** keyword and pass an array of search terms. In this case, the boolean **OR** operator is used.  
curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"terms\\": { \\"release_date\\": [\\"1970\\", \\"2008-12-25\\"] }}}"
```JSON
$body ='
{
  "query":
  {
    "terms": {"release_date": ["1970", "2020-12-25"]}
  },
  "_source": ["title", "release_date", "format"]
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -Headers @{'Content-Type'='application/json; charset=utf-8'} -Method POST -Body $body).Content;

## Multi-Match Query Clause with Boosting
> It searches for a text or phrase across multiple fields instead of just one.

curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"multi_match\\": { \\"query\\": \\"20th\\", \\"fields\\": [\\"studio\\", \\"description\\", \\"title\\"] }}}"
```JSON
$body ='
{
  "query":
  {
    "multi_match": {"query": "20th", "fields": ["studio", "description", "title"]}
  }
}';
```
When searching across multiple fields, there might be a need to boost the score in a certain field. In the next query, the *description* field is boosted by a factor of 3 in order to increase its importance, which, in turn, will increase the relevance of documents with a value of *20th* in the *query* field.

**Note**: Boosting does not imply that the calculated score gets multiplied by the boost factor. The actual boost value that is applied goes through normalization and some internal optimization. For more information on how boosting works go to [Elasticsearch Reference](https://www.elastic.co/guide/en/elasticsearch/guide/current/query-time-boosting.html).
```JSON
$body ='
{
  "query":
  {
    "multi_match": {"query": "20th", "fields": ["studio", "description^3", "title"]}
  }
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -Headers @{'Content-Type'='application/json; charset=utf-8'} -Method POST -Body $body).Content;

## Range Query Clause
> It is used to search number, date, and string fields using the operators **gt (greater_than), gte (greater_than_or_equal), lt (less_than), lte (less_than_or_equal)**.

curl -X POST "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"range\\": { \\"release_date\\": { \\"gte\\": \\"2008\\", \\"format\\": \\"yyyy\\" }}}}"
```JSON
$body ='
{
  "query":
  {
    "range":
    {
      "release_date":
      {
        "gte": "01/01/2008",
        "lte": "2010",
        "format": "dd/MM/yyyy||yyyy"
      }
    }
  }
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search/?pretty" -Headers @{'Content-Type'='application/json; charset=utf-8'} -Method POST -Body $body).Content;

## Bool Query Clause
> It is a compound query clause and is used to combine multiple query clauses using boolean operators. The three supported boolean operators are **must (AND)**, **must_not (NOT)**, and **should (OR)**.

For the **must** query clause, all queries within this clause must match a document for it to be returned. The highest priority for this clause is to score the documents. For instance, to search for *war* movies, in *dvd* format, and release between 1970 and 2000, run the query below.
```JSON
$body ='
{
  "query":
  {
    "bool":
    {
      "must": [{"match": {"genres": "war"}}, {"match": {"format": "dvd"}}, {"range": {"release_date": {"gte": 1970, "lte": 2000}}}]
    }
  },
  "from": 0,
  "size": 5,
  "_source": ["title", "release_date"],
  "sort": {"_score": "desc"}
}';
```
For the **must_not** query clause, any document that match the query within this clause will be excluded from the result set. For example, the following query will exclude all *war* movies.
```JSON
$body ='
{
  "query":
  {
    "bool":
    {
      "must_not": [{"match": {"genres": "war"}}]
    }
  },
  "_source": ["title", "release_date"]
}';
```
The **should** query clause differs from the other queries with regards to its functionality. In a [query context](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html), if **must** and **filter** queries are present, the **should** query clause helps to influence the score. However, if the *bool* query is in a [filter context](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html) or has neither **must** nor **filter** queries, then at least one of the **should** queries must match a document. The following query will search for *comedy* or *drama* movies only; i.e., if one of the criteria matches, the document will be returned.
```JSON
$body ='
{
  "query":
  {
    "bool":
    {
      "should": [{"match": {"genres": "Comedy"}}, {"match": {"genres": "drama"}}]
    }
  },
  "_source": ["title", "release_date"]
}';
```
The **filter** query clause is similar to the **must** query clause, in that if a **filter** clause is used, then the query must also appear in the matching documents, but it does not contribute to the score. The following query will search for *comedy* or *drama* movies only, but with a *rating* of *pg*.
```JSON
$body ='
{
  "query":
  {
    "bool":
    {
      "should": [{"match": {"genres": "Comedy"}}, {"match": {"genres": "war"}}],
      "filter": {"term": {"rating": "pg"}}
    }
  },
  "_source": ["title", "release_date"]
}';
```
## Basic Match Query Using Only the Query String
> Basic queries are done using only the **q** query parameter in the URL.

Search the index *movies-eng* for the value *les* in any field and return at most 5 (defaults to 10) documents.  
curl -X GET "http://elasticsearch.dev.local/movies-eng/_search?q=les&size=5&pretty" -H "Content-Type: application/json"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search?q=les&size=5&pretty" -Method GET).Content;

Search field *title* in the index *movies-eng* for value *Les Misérables* and return at most 5 documents.  
curl -X GET "http://elasticsearch.dev.local/movies-eng/_search?q=title:Les+Misérables&size=5&pretty" -H "Content-Type: application/json"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search?q=title:Les Misérables&size=5&pretty" -Method GET).Content;

## Searching Nested Objects
> Since nested objects are indexed as separate hidden documents and managed by Elasticsearch, they cannot be queried directly. Instead, nested queries are required to access them.

curl -X POST -H "Content-Type:application/json; charset=utf-8" "http://elasticsearch.dev.local/movies-eng/_search?pretty" -d "{\\"query\\": {\\"nested\\": {\\"path\\": \\"cast_and_crew\\", \\"score_mode\\": \\"avg\\", \\"query\\": {\\"bool\\": {\\"must\\": [{\\"match\\": {\\"cast_and_crew.full_name\\": \\"Amanda Seyfried\\"}}, {\\"match\\": {\\"cast_and_crew.gender\\": \\"Female\\"}}]}}}}}"
```JSON
$body ='
{
  "query":
  {
    "bool":
    {
      "must": [{"match": {"genres": "comedy"}},
               {
                 "nested":
                 {
                   "path": "cast_and_crew",
                   "score_mode": "avg",
                   "query":
                   {
                     "bool":
                     {
                       "must": [{"match": {"cast_and_crew.full_name": "Brooks"}},
                                {"match": {"cast_and_crew.role": "actor"}}]
                     }
                   }
                 }
               }]
    }
  },
  "_source": ["title", "rating", "release_date"]
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search?pretty" -Method POST -Headers @{'Content-Type'='application/json; charset=utf-8'} -Body $body).Content;

```JSON
$body ='
{
  "query":
  {
    "nested":
    {
      "path": "cast_and_crew",
      "score_mode": "avg",
      "query":
      {
        "bool":
        {
          "must": [{"match": {"cast_and_crew.full_name": "Brooks"}},
                   {"match": {"cast_and_crew.role": "actor"}}]
        }
      }
    }
  },
  "_source": ["title", "rating", "release_date"]
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_search?pretty" -Method POST -Headers @{'Content-Type'='application/json; charset=utf-8'} -Body $body).Content;

# Flushing the Transaction Log
The translog helps prevent data loss in the event of a node failure. It is designed to help a shard recover operations that may otherwise have been lost between flushes. The log is committed to disk every 5 seconds, or upon each successful index, delete, update, or bulk request, whichever occurs first. Changes to Lucene are only persisted to disk during a Lucene commit, which is a relatively heavy operation and so cannot be performed after every index or delete operation. Changes that happen after one commit and before another will be lost in the event of process exit or hardware failure.

To prevent this data loss, each shard has a transaction log or write ahead log associated with it. Any index or delete operation is written to the translog after being processed by the internal Lucene index. In the event of a crash, recent transactions can be replayed from the transaction log when the shard recovers.

An Elasticsearch flush is the process of performing a Lucene commit and starting a new translog. It is done automatically in the background in order to make sure the transaction log doesn't grow too large, which would make replaying its operations take a considerable amount of time during recovery.

Compared to refreshing an index shard, the really expensive operation is flushing its transaction log, which involves a Lucene commit. Elasticsearch performs flushes based on a number of triggers that may be changed at run time. By delaying flushes or disabling them completely, indexing throughput can increase, but the delayed flush will of course take longer when it eventually happens.

By increasing the **index.translog.flush_threshold_size** from the default 512MB to, for example, 1GB, it allows larger segments to accumulate in the translog before a flush occurs. By letting larger segments build, flush occurs less often, and the larger segments merge less often. All of this adds up to less disk I/O overhead and better indexing rates. Of course, a corresponding amount of free heap memory will be required  to accumulate the extra buffering space.

# Metrics Queries
## Thread Pool
**Display the thread pool state using the thread_pool API**  
curl -X GET "http://elasticsearch.dev.local/_cat/thread_pool/search?v&h=host,name,active,rejected,completed"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cat/thread_pool/search?v&h=host,name,active,rejected,completed" -Method GET).Content;

## Index
**Existence of an index can be determined by sending a GET request to the index. If the HTTP response is 200, it exists; if it is 404, it does not exist.**  
curl -X GET "http://elasticsearch.dev.local/movies-eng/?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/?pretty" -Method GET).Content;

**Display indexes information**  
curl -X GET "http://elasticsearch.dev.local/_cat/indices?v"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cat/indices?v" -Method GET).Content;

**Delete an index**  
**This command deletes the index, which cannot be undone**  
curl -X DELETE "http://elasticsearch.dev.local/index-name"  
Invoke-WebRequest -Uri "http://elasticsearch.dev.local/index-name" -Method DELETE;

**Index stats**  
curl -X GET "http://elasticsearch.dev.local/movies-eng/_stats?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_stats?pretty" -Method GET).Content;

**Return all documents from all indexes in a cluster**  
curl -X GET "http://elasticsearch.dev.local/_search/?pretty" -H "Content-Type: application/json" -d "{ \\"query\\": { \\"match_all\\": {} }}"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_search/?pretty" -Method GET).Content;  
Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_search/?pretty" -Method GET;

**Return the number of documents in the given index (movies-eng) for the given key (title) and given value (patton)**  
curl -X GET -H "Content-Type:application/json; charset=utf-8" "http://elasticsearch.dev.local/movies-eng/_count?q=title:patton&pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_count?q=title:patton&pretty" -Method GET).Content;

**Return the total number of documents in the given index (movies-eng)**  
curl -X GET -H "Content-Type:application/json; charset=utf-8" "http://elasticsearch.dev.local/movies-eng/_count?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/movies-eng/_count?pretty" -Method GET).Content;

## Nodes and Cluster
**Cluster stats**  
curl -X GET "http://elasticsearch.dev.local/_cluster/stats?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cluster/stats?pretty" -Method GET).Content;

**Cluster dynamic settings**  
curl -X GET "http://elasticsearch.dev.local/_cluster/settings"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cluster/settings/?pretty" -Method GET).Content;

**Health of the cluster**  
**Red** Some shards could not be allocated in the cluster.  
**Yellow** The primary shard is allocated, but the replicas could not be allocated.  
**Green** Primary and replica shards are allocated correctly.  
curl -X GET "http://elasticsearch.dev.local/_cluster/health?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cluster/health?pretty" -Method GET).Content;

**Nodes stats**  
curl -X GET "http://elasticsearch.dev.local/_nodes/stats?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_nodes/stats?pretty" -Method GET).Content;

**Display useful information from the Elasticsearch nodes**  
hostname, role (master, data, nothing), free disk space, heap used, ram used, file descriptors used, load  
curl -X GET "http://elasticsearch.dev.local/_cat/nodes?v&h=host,r,d,hc,rc,fdc,l"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cat/nodes?v&h=host,r,d,hc,rc,fdc,l" -Method GET).Content;

**Shard allocation information (Shards movement have major impact on cluster performances)**  
curl -X GET "http://elasticsearch.dev.local/_cat/shards?v"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_cat/shards?v" -Method GET).Content;

**Recovery information comes under the form of a JSON output**  
curl -X GET "http://elasticsearch.dev.local/_recovery?pretty&active_only"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_recovery?pretty&active_only" -Method GET).Content;

**Display metrics to understand how the workload weights on the memory**  
curl -X GET "http://elasticsearch.dev.local/_nodes/stats/?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_nodes/stats/?pretty" -Method GET).Content;

**All the cluster settings (can be extremely verbose)**  
curl -X GET "http://elasticsearch.dev.local/_settings"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_settings/?pretty" -Method GET).Content;

# Backup
**Check if there are any repositories setup; a blank response indicates there are no repositories setup**  
curl -X GET "http://elasticsearch.dev.local/_snapshot/_all?pretty=true"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/_all?pretty=true" -Method GET).Content;

**Create a repository**  
curl -X PUT "http://elasticsearch.dev.local/_snapshot/index-name-backup" -H "Content-Type: application/json" -d "{\\"type\\": \\"fs\\", \\"settings\\": {\\"compress\\": true, \\"location\\": \\"c:/db/elasticsearch/es-backup\\"}}
```JSON
$body ='
{
  "type": "fs",
  "settings": {"compress": true, "location": "c:/db/elasticsearch/es-backup"}
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/index-name-backup" -Method PUT -Headers @{'Content-Type'='application/json; charset=utf-8'} -Body $body).Content;

**List given snapshot**  
curl -X GET "http://elasticsearch.dev.local/_snapshot/index-name-backup/_all?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/index-name-backup/_all?pretty" -Method GET).Content;

**Create a backup of the entire cluster**  
curl -X PUT "http://elasticsearch.dev.local/_snapshot/index-name-backup/snapshot_1?wait_for_completion=true"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/index-name-backup/snapshot_1?wait_for_completion=true" -Method PUT -Headers @{'Content-Type'='application/json; charset=utf-8'}).Content;

**To restore a snapshot**  
curl -X POST "http://elasticsearch.dev.local/_snapshot/index-name-backup/snapshot_1/_restore?wait_for_completion=true"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/index-name-backup/snapshot_1/_restore?wait_for_completion=true" -Method POST -Headers @{'Content-Type'='application/json; charset=utf-8'}).Content;

**Delete given snapshot**  
curl -X DELETE "http://elasticsearch.dev.local/_snapshot/index-name-backup/snapshot-name"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/index-name-backup/snapshot-name" -Method DELETE).Content;

**Repository Cleanup**  
curl -X POST "http://elasticsearch.dev.local/_snapshot/index-name-backup/_cleanup?pretty"  
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/index-name-backup/_cleanup?pretty" -Method POST).Content;

**Repository Verification**  
**The verify parameter can be used to explicitly disable the repository verification when registering or updating a repository**  
curl -X PUT "http://elasticsearch.dev.local/_snapshot/my_unverified_backup?verify=false&pretty" -H "Content-Type: application/json" -d "{\\"type\\": \\"fs\\", \\"settings\\": {\\"location\\": \\"c:/db/elasticsearch/es-backup\\"}}"
```JSON
$body ='
{
  "type": "fs",
  "settings": {"location": "c:/db/elasticsearch/es-backup"}
}';
```
(Invoke-WebRequest -Uri "http://elasticsearch.dev.local/_snapshot/my_unverified_backup?verify=false&pretty" -Method PUT -Headers @{'Content-Type'='application/json; charset=utf-8'} -Body $backup).Content;






????????????????????????????
Fuzzy Queries
Fuzzy matching can be enabled on Match and Multi-Match queries to catch spelling errors. The degree of fuzziness is specified based on the Levenshtein distance from the original word, i.e. the number of one-character changes that need to be made to one string to make it the same as another string.

POST /bookdb_index/book/_search
{
    "query": {
        "multi_match" : {
            "query" : "comprihensiv guide",
            "fields": ["title", "summary"],
            "fuzziness": "AUTO"
        }
    },
    "_source": ["title", "summary", "publish_date"],
    "size": 1
}
[Results]
"hits": [
  {
    "_index": "bookdb_index",
    "_type": "book",
    "_id": "4",
    "_score": 2.4344182,
    "_source": {
      "summary": "Comprehensive guide to implementing a scalable search engine using Apache Solr",
      "title": "Solr in Action",
      "publish_date": "2014-04-05"
    }
  }
]
Note: Instead of specifying "AUTO" you can specify the numbers 0, 1, or 2 to indicate the maximum number of edits that can be made to the string to find a match. The benefit of using "AUTO" is that it takes into account the length of the string. For strings that are only 3 characters long, allowing a fuzziness of 2 will result in poor search performance. Therefore it's recommended to stick to "AUTO" in most cases.

Wildcard Query
Wildcard queries allow you to specify a pattern to match instead of the entire term. ? matches any character and * matches zero or more characters. For example, to find all records that have an author whose name begins with the letter ‘t’:

POST /bookdb_index/book/_search
{
    "query": {
        "wildcard" : {
            "authors" : "t*"
        }
    },
    "_source": ["title", "authors"],
    "highlight": {
        "fields" : {
            "authors" : {}
        }
    }
}
[Results]
"hits": [
  {
    "_index": "bookdb_index",
    "_type": "book",
    "_id": "1",
    "_score": 1,
    "_source": {
      "title": "Elasticsearch: The Definitive Guide",
      "authors": [
        "clinton gormley",
        "zachary tong"
      ]
    },
    "highlight": {
      "authors": [
        "zachary <em>tong</em>"
      ]
    }
  },
  {
    "_index": "bookdb_index",
    "_type": "book",
    "_id": "2",
    "_score": 1,
    "_source": {
      "title": "Taming Text: How to Find, Organize, and Manipulate It",
      "authors": [
        "grant ingersoll",
        "thomas morton",
        "drew farris"
      ]
    },
    "highlight": {
      "authors": [
        "<em>thomas</em> morton"
      ]
    }
  },
  {
    "_index": "bookdb_index",
    "_type": "book",
    "_id": "4",
    "_score": 1,
    "_source": {
      "title": "Solr in Action",
      "authors": [
        "trey grainger",
        "timothy potter"
      ]
    },
    "highlight": {
      "authors": [
        "<em>trey</em> grainger",
        "<em>timothy</em> potter"
      ]
    }
  }
]


Regexp Query
Regexp queries allow you to specify more complex patterns than wildcard queries.

POST /bookdb_index/book/_search
{
    "query": {
        "regexp" : {
            "authors" : "t[a-z]*y"
        }
    },
    "_source": ["title", "authors"],
    "highlight": {
        "fields" : {
            "authors" : {}
        }
    }
}
[Results]
"hits": [
  {
    "_index": "bookdb_index",
    "_type": "book",
    "_id": "4",
    "_score": 1,
    "_source": {
      "title": "Solr in Action",
      "authors": [
        "trey grainger",
        "timothy potter"
      ]
    },
    "highlight": {
      "authors": [
        "<em>trey</em> grainger",
        "<em>timothy</em> potter"
      ]
    }
  }
]

Match Phrase Prefix
Match phrase prefix queries provide search-as-you-type or a poor man’s version of autocomplete at query time without needing to prepare your data in any way. Like the match_phrase query, it accepts a slop parameter to make the word order and relative positions somewhat less rigid. It also accepts the max_expansions parameter to limit the number of terms matched in order to reduce resource intensity.

POST /bookdb_index/book/_search
{
    "query": {
        "match_phrase_prefix" : {
            "summary": {
                "query": "search en",
                "slop": 3,
                "max_expansions": 10
            }
        }
    },
    "_source": [ "title", "summary", "publish_date" ]
}
[Results]
"hits": [
      {
        "_index": "bookdb_index",
        "_type": "book",
        "_id": "4",
        "_score": 0.5161346,
        "_source": {
          "summary": "Comprehensive guide to implementing a scalable search engine using Apache Solr",
          "title": "Solr in Action",
          "publish_date": "2014-04-05"
        }
      },
      {
        "_index": "bookdb_index",
        "_type": "book",
        "_id": "1",
        "_score": 0.37248808,
        "_source": {
          "summary": "A distibuted real-time search and analytics engine",
          "title": "Elasticsearch: The Definitive Guide",
          "publish_date": "2015-02-07"
        }
      }
    ]
Note: Query-time search-as-you-type has a performance cost. A better solution is index-time search-as-you-type. Check out the Completion Suggester API or the use of Edge-Ngram filters for more information.

Query String
The query_string query provides a means of executing multi_match queries, bool queries, boosting, fuzzy matching, wildcards, regexp, and range queries in a concise shorthand syntax. In the following example, we execute a fuzzy search for the terms “search algorithm” in which one of the book authors is “grant ingersoll” or “tom morton.” We search all fields but apply a boost of 2 to the summary field.

POST /bookdb_index/book/_search
{
    "query": {
        "query_string" : {
            "query": "(saerch~1 algorithm~1) AND (grant ingersoll)  OR (tom morton)",
            "fields": ["title", "authors" , "summary^2"]
        }
    },
    "_source": [ "title", "summary", "authors" ],
    "highlight": {
        "fields" : {
            "summary" : {}
        }
    }
}
[Results]
"hits": [
  {
    "_index": "bookdb_index",
    "_type": "book",
    "_id": "2",
    "_score": 3.571021,
    "_source": {
      "summary": "organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization",
      "title": "Taming Text: How to Find, Organize, and Manipulate It",
      "authors": [
        "grant ingersoll",
        "thomas morton",
        "drew farris"
      ]
    },
    "highlight": {
      "summary": [
        "organize text using approaches such as full-text <em>search</em>, proper name recognition, clustering, tagging"
      ]
    }
  }
]
Simple Query String
The simple_query_string query is a version of the query_string query that is more suitable for use in a single search box that is exposed to users because it replaces the use of AND/OR/NOT with +/|/-, respectively, and it discards invalid parts of a query instead of throwing an exception if a user makes a mistake.

POST /bookdb_index/book/_search
{
    "query": {
        "simple_query_string" : {
            "query": "(saerch~1 algorithm~1) + (grant ingersoll)  | (tom morton)",
            "fields": ["title", "authors" , "summary^2"]
        }
    },
    "_source": [ "title", "summary", "authors" ],
    "highlight": {
        "fields" : {
            "summary" : {}
        }
    }
}




Nested mapping and filter to the rescue
Luckily ElasticSearch provides a way for us to be able to filter on multiple fields within the same objects in arrays; mapping such fields as nested. To try this out, let's create ourselves a new index with the "actors" field mapped as nested.

This happens because movie documents no longer have cast.firstName fields. Instead each element in the cast array is, internally in ElasticSearch, indexed as a separate document.


```JSON
$body ='
{
  "query":
  {
    "filtered":
    {
      "query":
      {
        "match_all": {}
      },
      "filter":
      {
        "term":
        {
          "full_name": "Cruise"
        }
      }
    }
  }
}';

'{  
   "query":  
   {  
     "nested":  
     {  
       "path": "cast_and_crew",  
       "score_mode": "avg",  
       "query":  
       {  
         "bool":  
         {  
           "must":  
           [  
             { "match": { "cast_and_crew.full_name": "Amanda Seyfried" } },  
             { "match": { "cast_and_crew.gender": "male" } }  
           ]  
         }  
       }  
     }  
   }  
}'