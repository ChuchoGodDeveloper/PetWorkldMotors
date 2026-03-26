# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_25_200132) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "menus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "idMenu", null: false
    t.integer "idModulo", null: false
    t.datetime "updated_at", null: false
    t.index ["idModulo"], name: "index_menus_on_idModulo"
  end

  create_table "modulos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "strNombreModulo", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perfils", force: :cascade do |t|
    t.boolean "bitAdministrador", default: false, null: false
    t.datetime "created_at", null: false
    t.string "strNombre_Perfil", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permisos_perfils", force: :cascade do |t|
    t.boolean "bitAgregar", default: false, null: false
    t.boolean "bitConsulta", default: false, null: false
    t.boolean "bitDetalle", default: false, null: false
    t.boolean "bitEditar", default: false, null: false
    t.boolean "bitEliminar", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "idModulo", null: false
    t.integer "idPerfil", null: false
    t.datetime "updated_at", null: false
    t.index ["idModulo"], name: "index_permisos_perfils_on_idModulo"
    t.index ["idPerfil"], name: "index_permisos_perfils_on_idPerfil"
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "idEstado_Usuario", default: 1, null: false
    t.integer "idPerfil", null: false
    t.string "strCorreo", null: false
    t.string "strNombreUsuario", null: false
    t.string "strNumeroCelular"
    t.string "strPwd", null: false
    t.datetime "updated_at", null: false
    t.index ["idPerfil"], name: "index_usuarios_on_idPerfil"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "menus", "modulos", column: "idModulo"
  add_foreign_key "permisos_perfils", "modulos", column: "idModulo"
  add_foreign_key "permisos_perfils", "perfils", column: "idPerfil"
  add_foreign_key "usuarios", "perfils", column: "idPerfil"
end
