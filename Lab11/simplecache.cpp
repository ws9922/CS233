#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  std::vector<SimpleCacheBlock> blocks = _cache[index];
  for (size_t i = 0; i < blocks.size(); i++){
    if(blocks[i].valid() && blocks[i].tag() == tag){
      return blocks[i].get_byte(block_offset);
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  std::vector<SimpleCacheBlock>& blocks = _cache[index];
  for(size_t i = 0; i < blocks.size(); i++){
    if(!blocks[i].valid()){
      blocks[i].replace(tag, data);
      return;
    }
  }
  blocks[0].replace(tag, data);
}
