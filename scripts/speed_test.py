import os
from dotenv import load_dotenv
from elasticsearch import Elasticsearch
from faker import Faker
import time
import numpy as np
import sys

ITERATIONS = 1000

def print_latencies(latencies):
    p50 = np.percentile(latencies, 50)*1000  # convert to milliseconds
    p95 = np.percentile(latencies, 95)*1000  
    p99 = np.percentile(latencies, 99)*1000  

    print("\nLatency Percentiles:")
    print(f"{'50th:':<10}{p50:>5.2f} ms")
    print(f"{'95th:':<10}{p95:>5.2f} ms")
    print(f"{'99th:':<10}{p99:>5.2f} ms")

def write_test(es, fake):
    print("*** Write Test ***")
    latencies = []
    for _ in range(ITERATIONS):
        start = time.perf_counter()
        es.index(index=os.getenv("ELASTIC_INDEX_NAME"), document={
            "field_1": fake.sentence(),
            "field_2": fake.sentence(),
            "field_3": fake.sentence(),
            "field_4": fake.sentence(),
            "field_5": fake.sentence(),
            "field_6": fake.sentence(),
            "field_7": fake.sentence(),
            "field_8": fake.sentence(),
            "field_9": fake.sentence(),
            "field_10": fake.sentence()
        })
        latencies.append(time.perf_counter() - start)
    print_latencies(latencies)

def read_test(es, fake):
    print("\n*** Read Test ***")
    latencies = []
    for _ in range(ITERATIONS):
        start = time.perf_counter()
        es.search(index=os.getenv("ELASTIC_INDEX_NAME"), query={"match": {"field_1": fake.word()}})
        latencies.append(time.perf_counter() - start)
    print_latencies(latencies)

if __name__ == "__main__":
    load_dotenv(override=True)

    if len(sys.argv) != 2 or sys.argv[1] not in ["external", "psc"]:
        print("Usage: python speed_test.py [external|psc]")
        sys.exit(1)

    if sys.argv[1] == "external":
        host = os.getenv("ELASTIC_EXTERNAL_ENDPOINT")
    else:
        host = os.getenv("ELASTIC_PSC_ENDPOINT")

    fake = Faker()
    fake.seed_instance(12345)

    es = Elasticsearch(
        hosts=host,
        basic_auth=(os.getenv("ELASTIC_USERNAME"), os.getenv("ELASTIC_PASSWORD"))
    )

    # Clear index of all documents
    es.delete_by_query(index=os.getenv("ELASTIC_INDEX_NAME"), query={"match_all": {}})
    es.indices.refresh(index=os.getenv("ELASTIC_INDEX_NAME"))

    # Perform write test
    write_test(es, fake)

    es.indices.refresh(index=os.getenv("ELASTIC_INDEX_NAME"))
    
    # Perform read test
    read_test(es, fake)



