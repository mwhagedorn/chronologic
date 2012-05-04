create keyspace ChronologicTest
  with placement_strategy = 'NetworkTopologyStrategy'
  and strategy_options = [{datacenter1 : 1}];

use ChronologicTest;

create column family Event
  with column_type = 'Standard'
  and comparator = 'UTF8Type'
  and default_validation_class = 'BytesType'
  and key_validation_class = 'BytesType'
  and memtable_operations = 0.0328125
  and memtable_throughput = 7
  and memtable_flush_after = 1440
  and rows_cached = 0.0
  and row_cache_save_period = 0
  and keys_cached = 200000.0
  and key_cache_save_period = 14400
  and read_repair_chance = 1.0
  and gc_grace = 864000
  and min_compaction_threshold = 4
  and max_compaction_threshold = 32
  and replicate_on_write = true
  and row_cache_provider = 'ConcurrentLinkedHashCacheProvider'
  and column_metadata = [
    {column_name : 'objects',
    validation_class : UTF8Type},
    {column_name : 'tokens',
    validation_class : UTF8Type},
    {column_name : 'timelines',
    validation_class : UTF8Type}];

create column family Object
  with column_type = 'Standard'
  and comparator = 'UTF8Type'
  and default_validation_class = 'BytesType'
  and key_validation_class = 'BytesType'
  and memtable_operations = 0.0328125
  and memtable_throughput = 7
  and memtable_flush_after = 1440
  and rows_cached = 0.0
  and row_cache_save_period = 0
  and keys_cached = 200000.0
  and key_cache_save_period = 14400
  and read_repair_chance = 1.0
  and gc_grace = 864000
  and min_compaction_threshold = 4
  and max_compaction_threshold = 32
  and replicate_on_write = true
  and row_cache_provider = 'ConcurrentLinkedHashCacheProvider';

create column family Subscription
  with column_type = 'Standard'
  and comparator = 'UTF8Type'
  and default_validation_class = 'BytesType'
  and key_validation_class = 'BytesType'
  and memtable_operations = 0.0328125
  and memtable_throughput = 7
  and memtable_flush_after = 1440
  and rows_cached = 0.0
  and row_cache_save_period = 0
  and keys_cached = 200000.0
  and key_cache_save_period = 14400
  and read_repair_chance = 1.0
  and gc_grace = 864000
  and min_compaction_threshold = 4
  and max_compaction_threshold = 32
  and replicate_on_write = true
  and row_cache_provider = 'ConcurrentLinkedHashCacheProvider';

create column family Timeline
  with column_type = 'Standard'
  and comparator = 'UTF8Type'
  and default_validation_class = 'BytesType'
  and key_validation_class = 'BytesType'
  and memtable_operations = 0.0328125
  and memtable_throughput = 7
  and memtable_flush_after = 1440
  and rows_cached = 0.0
  and row_cache_save_period = 0
  and keys_cached = 200000.0
  and key_cache_save_period = 14400
  and read_repair_chance = 1.0
  and gc_grace = 864000
  and min_compaction_threshold = 4
  and max_compaction_threshold = 32
  and replicate_on_write = true
  and row_cache_provider = 'ConcurrentLinkedHashCacheProvider';