<script setup>
import InventoryTable from './components/InventoryTable.vue'
</script>

<template>
  <div class="app">
    <header>
      <h1>Inventory Management System</h1>
    </header>
    <main>
      <InventoryTable />
    </main>
  </div>
</template>

<style>
.app {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

header {
  margin-bottom: 30px;
  text-align: center;
}

h1 {
  color: #2c3e50;
  font-size: 2.5em;
}
</style>
