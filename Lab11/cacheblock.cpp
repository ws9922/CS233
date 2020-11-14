#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t index = _index << _cache_config.get_num_block_offset_bits();
  uint32_t tag = _tag << (32 - _cache_config.get_num_tag_bits());
  return index | tag;
}
