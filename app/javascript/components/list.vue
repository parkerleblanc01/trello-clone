<template>
  <div class="list">
    <h6>{{ list.name }}</h6>

    <draggable v-model="list.cards" :options="{group: 'cards'}" class="dragArea" @change="cardMoved">
      <div v-for="(card, index) in list.cards" class="card card-body mb-3">
        {{ card.name }}
      </div>
    </draggable>

    <a v-if="!editing" v-on:click="startEditing">Add a card</a>
    <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-1"></textarea>
    <button v-if="editing" v-on:click="submitMessages" class="btn btn-secondary">Add</button>
    <a v-if="editing" v-on:click="editing=false">Cancel</a>
  </div>
</template>

<script>
import draggable from 'vuedraggable'

export default{
  components: { draggable },
  props: ["list"],

  data: function() {
    return {
      editing: false,
      message: ""
    }
  },

  methods: {
    startEditing: function(){
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus() })
    },
    cardMoved: function(event) {
      const evt = event.added || event.moved
      if (evt == undefined) { return }

      const element = evt.element
      const list_index = window.store.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id
        })
      })

      var data = new FormData
      data.append("card[list_id]", window.store.lists[list_index].id)
      data.append("card[position]", evt.newIndex + 1)

      Rails.ajax({
        beforeSend: () => true,
        url: `/cards/${element.id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },

    submitMessages: function() {
      var data = new FormData
      data.append("card[list_id]", this.list.id)
      data.append("card[name]", this.message)

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = window.store.lists.findIndex(item => item.id == this.list.id)
          window.store.lists[index].cards.push(data)
          this.message = ""
          this.$nextTick(() => { this.$refs.message.focus() })
        },
        beforeSend: function() {return true}
      })
    }
  }

}
</script>

<style scoped>
.dragArea {
  min-height: 20px;
}

.list{
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  padding: 10px;
  margin-right: 10px;
  vertical-align: top;
  width: 270px;
}
</style>
